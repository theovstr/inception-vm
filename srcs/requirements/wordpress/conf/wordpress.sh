#!/bin/bash

# Load secrets into env (Docker mounts them at /run/secrets/<name>)
export BDD_USER_PASSWORD="$(cat /run/secrets/db_password)"
set -a
source /run/secrets/credentials
set +a

sleep 5

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

mkdir -p /var/www/html/wordpress/
cd /var/www/html/wordpress/

# Configure PHP-FPM to listen on TCP 9000 (must happen before starting PHP-FPM)
sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf
mkdir -p /run/php

# Skip full setup if WordPress is already installed (from previous run or volume)
if [ -f /var/www/html/wordpress/wp-config.php ]; then
	echo "[========WP ALREADY INSTALLED - SKIPPING SETUP========]"
	chown -R www-data:www-data /var/www/html/wordpress
	exec "$@"
fi

chmod -R 755 /var/www/html/wordpress/
chown -R www-data:www-data /var/www/html/wordpress

echo "[========WP INSTALLATION STARTED========]"
find /var/www/html/wordpress/ -mindepth 1 -delete

# Retry wp core download (network can be flaky on container startup)
for i in 1 2 3 4 5; do
	if wp core download --allow-root; then
		break
	fi
	echo "[Retry $i/5] wp core download failed, waiting 10s..."
	sleep 10
done

if [ ! -f /var/www/html/wordpress/wp-config-sample.php ]; then
	echo "[ERROR] WordPress download failed. Starting PHP-FPM anyway - site may not work."
	exec "$@"
fi

wp core config --dbhost=mariadb:3306 --dbname="$BDD_NAME" --dbuser="$BDD_USER" --dbpass="$BDD_USER_PASSWORD" --allow-root
wp core install --url="$DOMAIN_NAME" --title="$TITLE" --admin_user="$WP_ADMIN_USER" --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WP_ADMIN_EMAIL" --allow-root
wp user create "$WP_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASSWORD" --allow-root
sleep 5

wp plugin install contact-form-7 --activate --allow-root
wp theme delete twentynineteen twentytwenty --allow-root
wp plugin delete hello --allow-root
wp plugin update --all --allow-root
# chown -R www-data:www-data /var/www/html/wordpress/wp-content/uploads

exec "$@"

