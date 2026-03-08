# Developer documentation

This doc explains how to set up the project from scratch and work with it as a developer.

## Prerequisites

- Docker
- Docker Compose
- Git

## Setup from scratch

### 1. Clone the repo

```bash
git clone <your-repo-url>
cd inception
```

### 2. Create the secrets folder

```bash
mkdir -p secrets
```

### 3. Create required secret files

**`secrets/db_password.txt`**  
One line: the password for the MariaDB user

**`secrets/db_root_password.txt`**  
One line: the root password for MariaDB.

**`secrets/credentials.txt`**  
One variable per line, for example:

```
BDD_USER=
BDD_NAME=
DOMAIN_NAME=theveste.42.fr
WP_ADMIN_EMAIL=
WP_ADMIN_USER=
WP_ADMIN_PASSWORD=
TITLE=inception
WP_USER_EMAIL=
WP_USER=
WP_USER_PASSWORD=
```

Replace `theveste` with your 42 login if needed. The admin username must not contain "admin" or "Admin".

### 4. Add hosts entry

Add to `/etc/hosts`:

```
127.0.0.1 theveste.42.fr
```

### 5. Create data directories

```bash
mkdir -p /Users/hiro/data/mariadb
mkdir -p /Users/hiro/data/wordpress
```

If you’re on a 42 VM, use `/home/<your-login>/data/` instead and update the paths in `docker-compose.yml` and the Makefile.

## Build and run

```bash
make
```

or

```bash
make start
```

This builds the images and starts all containers. The first run can take a few minutes while WordPress installs.

## Useful commands

| Command | What it does |
|---------|--------------|
| `make` / `make start` | Build and start everything |
| `make stop` | Stop all containers |
| `make logs` | Show logs from all services |
| `make delete` | Remove data directories (careful) |
| `make supp` | Stop, remove volumes, prune images |

## Containers and volumes

### Containers

- **mariadb** – MariaDB database
- **wordpress** – WordPress + PHP-FPM
- **nginx** – NGINX (only entrypoint, port 443)

### Volumes

- **db** – MariaDB data (persistent)
- **wp** – WordPress files (persistent)

Data is stored in:

- `/Users/hiro/data/mariadb` (or `/home/<login>/data/mariadb`)
- `/Users/hiro/data/wordpress` (or `/home/<login>/data/wordpress`)

### Persistence

After `make stop`, the data stays in those directories. When you run `make start` again, the containers use the same data.

To wipe everything:

```bash
make supp
```

Then recreate the data directories and run `make start` again for a fresh install.

## Project structure

```
inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/           # created by you, not in git
│   ├── db_password.txt
│   ├── db_root_password.txt
│   └── credentials.txt
└── srcs/
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   └── tools/
        │       └── mariadb.sh
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        │       └── nginx.conf
        └── wordpress/
            ├── Dockerfile
            └── conf/
                └── wordpress.sh
```

## Debugging

- **Connect to MariaDB**:  
  `docker exec -it mariadb mariadb -u user -p wordpress`  
  (password from `secrets/db_password.txt`)

- **Shell in a container**:  
  `docker exec -it mariadb bash` (or `wordpress`, `nginx`)

- **View logs**:  
  `make logs` or `docker compose -f srcs/docker-compose.yml logs <service>`
