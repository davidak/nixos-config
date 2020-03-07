{ config, lib, pkgs, ... }:

with lib;
let
  satzgenerator = pkgs.callPackage ../packages/satzgenerator.nix { };
  gunicorn = pkgs.python36Packages.gunicorn;
  python = pkgs.python36Packages.python;
  cfg = config.services.satzgenerator;
  user = "satzgenerator";
  group = "satzgenerator";
  default_home = "/var/lib/satzgenerator";
  satzgenerator_config = pkgs.writeText "satzgenerator-config.ini" ''
    [satzgenerator]
    database=${cfg.database.type}

    ${lib.optionalString (cfg.database.type == "sqlite") ''
      [satzgenerator.sqlite]
      file=${cfg.database.name}.db
    ''}

    ${lib.optionalString (cfg.database.type == "mysql") ''
      [satzgenerator.mysql]
      user=${cfg.database.user}
      password=${cfg.database.password}
      database=${cfg.database.name}
      host=${cfg.database.host}
      port=${toString cfg.database.port}
    ''}
  '';
in
{
  options.services.satzgenerator = {
    enable = mkEnableOption "Satzgenerator";

    bind = mkOption {
      type = types.str;
      default = "127.0.0.1:8000";
      example = "0.0.0.0:8000";
      description = "Bind address for this service.";
    };

    workers = mkOption {
      type = types.int;
      default = 2;
      example = 5;
      description = "number of gunicorn workers. generally recommended is 2x CPUs +1.";
    };

    database = {
      type = mkOption {
        type = types.enum ["sqlite" "mysql"];
        default = "mysql";
        example = "sqlite";
        description = "Database type. Supported are sqlite and mysql.";
      };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Host of the database. Not needed for sqlite.";
      };

      port = mkOption {
        type = types.int;
        default = 3306;
        description = "Database port. Not needed for sqlite.";
      };

      user = mkOption {
        type = types.str;
        default = "satzgenerator";
        description = ''
          Database user. It must exists and has access to the database.
          Not needed for sqlite.
        '';
      };

      password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The database users password. Not needed for sqlite.";
      };

      name = mkOption {
        type = types.str;
        default = "satzgenerator";
        description = "Name of the database. Not needed for sqlite.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.satzgenerator = {
      description = "Satzgenerator";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "mysql.service" ];
      restartIfChanged = true;

      environment = let
        penv = python.buildEnv.override {
          extraLibs = [ satzgenerator ];
        };
      in {
        PYTHONPATH = "${penv}/${python.sitePackages}/";
      };

      preStart = ''
        ln -sf ${satzgenerator_config} ${default_home}/config.ini
      '';

      serviceConfig = {
        Type = "simple";
        User = user;
        Group = group;
        WorkingDirectory = default_home;
        ExecStart = ''${gunicorn}/bin/gunicorn satzgenerator:app \
        --bind=${cfg.bind} \
        --workers ${toString cfg.workers}
        '';
      };
    };

    users.extraUsers = [{
      name = user;
      group = group;
      home = default_home;
      createHome = true;
    }];

    users.extraGroups = [{
      name = group;
    }];
  };

  meta = with lib; {
    maintainers = with maintainers; [ davidak ];
  };
}
