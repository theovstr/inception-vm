all: start

start:
	mkdir -p /Users/hiro/data/mariadb
	mkdir -p /Users/hiro/data/wordpress
	docker compose --project-directory srcs up --build

stop:
	docker compose --project-directory srcs down

delete:
	 sudo rm -rf /Users/hiro/data/*

supp:
	docker compose --project-directory srcs down -v
	docker system prune -af


clean : stop delete supp

logs:
	docker compose --project-directory srcs logs

.PHONY: start all logs delete supp
