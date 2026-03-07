FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y mariadb-server vim zsh

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY tools/mariadb.sh /

ENTRYPOINT [ "/mariadb.sh", "mysqld" ]