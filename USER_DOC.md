# User documentation

This doc explains how to use the Inception project once it’s set up.

## What does this stack do?

You get a WordPress site running behind NGINX with HTTPS. The stack has:

- **NGINX** – web server (HTTPS only)
- **WordPress** – the CMS
- **MariaDB** – database for WordPress

## Start and stop

### Start

```bash
make
```

or

```bash
make start
```

This builds the images (if needed) and starts all containers.

### Stop

```bash
make stop
```

This stops all containers. Your data (database, WordPress files) stays in the volumes.

## Access the site

- **Website**: https://theveste.42.fr  or https://localhost:443
  (replace `theveste` with your 42 login if you changed it)

- **Admin panel**: https://theveste.42.fr/wp-admin

You need to add the domain in your hosts file:

```
127.0.0.1 theveste.42.fr
```

On macOS/Linux: edit `/etc/hosts`.

## Credentials

### Where they are

Credentials are in the `secrets` folder at the root of the project:

- `db_password.txt` – password for the MariaDB user
- `db_root_password.txt` – root password for MariaDB
- `credentials.txt` – WordPress admin, extra user, DB name, etc.

### How to manage them

- Create the `secrets` folder if it doesn’t exist
- Create the files above with the right content
- Don’t commit them to git (they’re in `.gitignore`)

For the exact format, see DEV_DOC.md.

## Check if services are running

```bash
docker ps
```

You should see containers for `nginx`, `wordpress`, and `mariadb`.

```bash
make logs
```

Shows logs from all services.

```bash
docker compose -f srcs/docker-compose.yml logs nginx
```

Shows only NGINX logs.

## Troubleshooting

- **Can’t connect to the site**: Check that the domain is in `/etc/hosts` and that the containers are running (`docker ps`).
- **SSL warning**: The certificate is self-signed. Your browser will warn you; accept it for local use.
- **Site not loading**: Wait a bit after `make start`; WordPress needs time to install and configure.
