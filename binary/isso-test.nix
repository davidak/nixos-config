{ pkgs, config, lib, ... }:
let

  isso = rec {
    port = "8081";
    website = pkgs.runCommand "isso-test-html" {} ''
      mkdir -p $out
      echo '
      <p>test1232</p>
      <script data-isso="/isso"
              src="/static/js/embed.dev.js"></script>
      <section id="isso-thread"></section>
      ' > $out/index.html
    '';
  };

in
{

  services.nginx = {
    enable = true;
    httpConfig = ''
      server {
        server_name localhost;
        location / {
          root ${isso.website};
        }
        location /static/js/ {
          alias ${pkgs.isso.js}/;
        }
        location /isso {
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Script-Name /isso;
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_pass http://localhost:${isso.port};
        }
      }
    '';
  };

  services.isso = {
    enable = true;
    config = {
      general.host = [ "localhost" "http://beta.davidak.de/" ];
      otherConfig = {
        server.listen = "http://localhost:${isso.port}";
      };
    };
  };

}
