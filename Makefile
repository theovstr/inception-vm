all: start

start:
	mkdir -p /home/theveste/data/mariadb
	mkdir -p /home/theveste/data/wordpress
	docker compose --project-directory srcs up --build

stop:
	docker compose --project-directory srcs down

delete:
	 sudo rm -rf /home/theveste/data/*

supp:
	docker container rm -f mariadb
	docker container rm -f wordpress
	docker container rm -f nginx
	docker volume rm srcs_db
	docker volume rm srcs_wp
	docker system prune -af


clean : stop delete supp

logs:
	docker compose --project-directory srcs logs

.PHONY: start all logs delete supp
