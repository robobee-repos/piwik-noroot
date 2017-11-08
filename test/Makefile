include ../utils/Makefile.help
include ../utils/Makefile.functions

NAME := piwik

test: setup ##@targets Starts docker compose.
	docker-compose -p ${NAME} -f test.yaml up
.PHONY: up

rm:
	docker-compose -p ${NAME} -f test.yaml stop

clean: rm
	docker-compose -p ${NAME} -f test.yaml rm -f
	sudo rm -rf root

setup:
	mkdir -p root/html
	mkdir -p root/db
	chmod o+rwX root/html
	chmod o+rwX root/db
.PHONY: setup

count-php-files:
	docker exec $(NAME)_piwik_1 find /var/www/html -iname \*.php|wc -l
.PHONY: count-php-files
