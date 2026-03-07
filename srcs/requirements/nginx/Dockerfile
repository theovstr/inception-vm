FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y

    
RUN apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/ssl/private /etc/ssl/certs

# Generate self-signed certificate
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=theveste.42.fr"

RUN openssl dhparam -out /etc/nginx/dhparam.pem 2048

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/html/wordpress

ENTRYPOINT ["nginx", "-g", "daemon off;"]