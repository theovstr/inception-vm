FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/^bind-address\s*=\s*127\.0\.0\.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/mariadb.sh /

ENTRYPOINT [ "/mariadb.sh", "mysqld" ]