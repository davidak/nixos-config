My NixOS VPS Configuration
==========================

Running several Websites and other services.

## Additional configuration steps

### Create databases and users

```
CREATE DATABASE piwik CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON piwik.* TO 'piwik'@'localhost' IDENTIFIED BY 'password';
CREATE DATABASE IF NOT EXISTS satzgenerator CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON satzgenerator.* TO 'satzgenerator'@'127.0.0.1' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
```

then delete unneeded users

```
SELECT user, host, password FROM mysql.user;
DROP USER 'root'@'atomic';
DROP USER 'root'@'::1';
DROP USER ''@'localhost';
DROP USER ''@'atomic';
```

and set a secure root password

```
$ mysqladmin -u root password newpass
```

### deploy websites

#### aww.davidak.de
```
git clone https://github.com/davidak/aww.git /var/www/aww/web/
chown aww:users -R /var/www/aww/web/
systemctl restart caddy.service
```

#### davidak.de
```
imac:Webseite davidak$ nikola build && nikola deploy
```

#### satzgenerator.de

Create a `secrets.nix` and set the `user` and `password` for the Satzgenerator.

```
[root@atomic:~]# cp nixos-config/machines/atomic/secrets.nix.dist secrets.nix
[root@atomic:~]# vim secrets.nix
```

...
