*This project has been created as part of the 42 curriculum by theveste.*

# Description

Inception is a Docker project where you set up a small web infrastructure from scratch. The goal is to run a WordPress site with nginx, mariadb, and php-fpm all in separate containers, without using any already created images.

You build your own Dockerfiles, configure everything yourself, and end up with a working WordPress site that you can access over HTTPS.


# Instructions

### Prerequisites

- Docker and Docker Compose installed (https://docs.docker.com/engine/install/) 
- A `secrets` folder at the root with the required files (see DEV_DOC.md)

### Setup

1. Clone the repo
2. Create the `secrets` folder and add your credential files
3. Add the domain to your `/etc/hosts` (sudo nano /etc/host) so it points to your machine: `127.0.0.1 theveste.42.fr`
4. Run `make` (or `make start`)

### Access

- Website: https://theveste.42.fr or https://localhost:443
- Admin panel: https://theveste.42.fr/wp-admin

### Stop

Run `make stop` to stop all containers.

# Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [NGINX](https://nginx.org/en/docs/)
- [WordPress](https://wordpress.org/support/)
- [MariaDB](https://mariadb.org/documentation/)

## Project description

### Docker

- **NGINX**: Serves the site over HTTPS (port 443 only). Uses TLS 1.2/1.3, forwards PHP requests to WordPress.
- **WordPress**: Runs PHP-FPM and WordPress. Gets the site from the web, configures it, connects to MariaDB.
- **MariaDB**: Database for WordPress. Stores all the site data.

### Design choices

- **Virtual Machines vs Docker**: VMs run a full OS and are heavy. Docker containers share the host kernel and run only what they need. They start faster, use less resources, and are easier to replicate. For this project, Docker is enough.
- **Secrets vs Environment Variables**: Env vars are visible in the process list. For passwords, we use Docker secrets. They’re stored in files and mounted into the container at runtime, so they’re not in the image or the command line.
- **Docker Network vs Host Network**: With `network: host`, the container shares the host’s network. We use a custom bridge network instead so containers can talk to each other by name (e.g. `wordpress:9000`) without exposing everything on the host.
- **Docker Volumes vs Bind Mounts**: Volumes are managed by Docker. Bind mounts point directly to a host folder. For this project we use volumes that store data in `/home/login/data` so the database and WordPress files persist across restarts.
