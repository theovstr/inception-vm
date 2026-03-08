all: start

start:
	mkdir -p /Users/hiro/data/mariadb
	mkdir -p /Users/hiro/data/wordpress
	docker compose -f srcs/docker-compose.yml up --build

stop:
	docker compose -f srcs/docker-compose.yml down

delete:
	 sudo rm -rf /Users/hiro/data/*

supp:
	docker compose -f srcs/docker-compose.yml down -v
	docker system prune -af


clean : stop delete supp

logs:
	docker compose -f srcs/docker-compose.yml logs

.PHONY: start all logs delete supp
