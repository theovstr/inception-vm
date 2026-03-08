# Inception — Understanding

## MariaDB bind-address: 127.0.0.1 → 0.0.0.0

Debian's default `50-server.cnf` sets `bind-address = 127.0.0.1`, so MariaDB only listens on localhost. In Docker, WordPress runs in a separate container and connects over the network (`mariadb:3306`). With 127.0.0.1, MariaDB would reject those connections. Setting `bind-address = 0.0.0.0` makes it listen on all interfaces so other containers can connect.

## MariaDB: run mysqld as mysql user, not root

MariaDB refuses to run as root and aborts with "Please consult the Knowledge Base to find out how to run mysqld as root!". The container runs as root by default, so `exec mysqld` fails. We use `exec mysqld --user=mysql` so mysqld runs as the `mysql` user and starts correctly.

## MariaDB: why mysqld must be PID 1

In Docker, the process with PID 1 is the main process. When you `docker stop`, Docker sends SIGTERM to PID 1. If PID 1 exits, the container stops. We kill the temporary MariaDB (started by `service mariadb start`), then `exec mysqld` so mysqld becomes PID 1—it receives signals correctly and keeps the container alive.

## NGINX: self-signed SSL certificate

The Inception subject requires NGINX on port 443 only, with a TLS v1.2/v1.3 certificate. We generate a self-signed cert with `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ... -out ... -subj "/CN=login.42.fr"`. `-x509` creates the cert, `-nodes` skips passphrase (needed for unattended start), `-subj` avoids prompts. The subject allows self-signed certs (browser warning is ok). NGINX needs `ssl_certificate` and `ssl_certificate_key` in its config to serve HTTPS.

## NGINX: COPY nginx.conf

`apt install nginx` creates `/etc/nginx/` with a default config (port 80, static HTML). We `COPY conf/nginx.conf /etc/nginx/nginx.conf` to replace it with our custom config: port 443 only, SSL, WordPress root, PHP-FPM proxy to wordpress:9000.

## NGINX: server block (subject + security)

**Subject:** `listen 443 ssl` only (no port 80), `ssl_protocols TLSv1.2 TLSv1.3`, `ssl_certificate`/`ssl_certificate_key`. `root /var/www/html/wordpress`, `try_files` for WordPress routing, `location ~ \.php$` with `fastcgi_pass wordpress:9000` for PHP. **Security:** `location ~ (\.\.|^/etc/)` blocks path traversal (404). `location = /wp-config.php` blocks direct access to config (404).
