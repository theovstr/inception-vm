User documentation

This doc explains how to use the Inception project once it's set up.

What does this stack do?

You get a WordPress site running behind NGINX with HTTPS. The stack has NGINX (web server), WordPress (the CMS), and MariaDB (database).


Start: make or make start
This builds the images (if needed) and starts all containers.


Stop: make stop
This stops all containers. Your data stays in the volumes.


Access the site

Website: https://theveste.42.fr or https://localhost:443
Admin panel: https://theveste.42.fr/wp-admin

You need to add the domain in your hosts file:

127.0.0.1 theveste.42.fr


On macOS/Linux: edit /etc/hosts.

Credentials

Where they are: in the `secrets` folder at the root of the project. You need db_password.txt, db_root_password.txt, and credentials.txt.

How to manage them: Create the `secrets` folder if it doesn't exist, add the files with the right content, and don't commit them to git (they're in .gitignore). For the exact format see DEV_DOC.md.

Check if services are running: docker ps
You should see containers for nginx, wordpress, and mariadb.

make logs
Shows logs from all services.


docker compose -f srcs/docker-compose.yml logs nginx
Shows only NGINX logs.


Troubleshooting

Can't connect to the site: Check that the domain is in /etc/hosts and that the containers are running (docker ps).
SSL warning: The certificate is self-signed. Your browser will warn you; accept it for local use.
Site not loading: Wait a bit after make start; WordPress needs time to install and configure.
