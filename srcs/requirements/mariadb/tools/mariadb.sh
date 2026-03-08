#!/bin/sh

# Load secrets into env (Docker mounts them at /run/secrets/<name>)
export BDD_USER_PASSWORD="$(cat /run/secrets/db_password)"
export BDD_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"
set -a
. /run/secrets/credentials
set +a

service mariadb start
 
sleep 5

{ 
    echo "FLUSH PRIVILEGES;"
    echo "CREATE DATABASE IF NOT EXISTS $BDD_NAME;"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$BDD_ROOT_PASSWORD';"
    echo "CREATE USER '$BDD_USER'@'%' IDENTIFIED BY '$BDD_USER_PASSWORD';"
    echo "GRANT ALL PRIVILEGES ON *.* TO '$BDD_USER'@'%';"
    echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$BDD_ROOT_PASSWORD';"
    echo "FLUSH PRIVILEGES;"
} | mysql

kill $(cat /var/run/mysqld/mysqld.pid)

exec mysqld --user=mysql
