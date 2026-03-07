FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y curl php php8.2-fpm php-mysql mariadb-client wget vim zsh git netcat-openbsd mycli && rm -rf /var/lib/apt/lists/*

COPY /conf/wordpress.sh /

RUN  chmod +x wordpress.sh

ENTRYPOINT ["./wordpress.sh", "php-fpm8.2", "-F"]