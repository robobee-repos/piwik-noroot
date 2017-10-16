include ../utils/Makefile.help
include ../utils/Makefile.functions

NAME := piwik
ROOT_DIR:=$(shell realpath root)
NGINX_CONF_DIR:=$(shell realpath nginx-in)

test: setup ##@targets Starts docker compose.
	export ROOT_DIR="$(ROOT_DIR)" \
	&& export NGINX_CONF_DIR="$(NGINX_CONF_DIR)" \
	&& docker-compose -p ${NAME} -f test.yaml up
.PHONY: up

rm:
	export ROOT_DIR="$(ROOT_DIR)" \
	&& export NGINX_CONF_DIR="$(NGINX_CONF_DIR)" \
	&& docker-compose -p ${NAME} -f test.yaml stop

clean: rm
	export ROOT_DIR="$(ROOT_DIR)" \
	&& export NGINX_CONF_DIR="$(NGINX_CONF_DIR)" \
	&& docker-compose -p ${NAME} -f test.yaml rm
	sudo rm -rf $(ROOT_DIR)

setup:
	mkdir -p $(ROOT_DIR)/html
	mkdir -p $(ROOT_DIR)/db
	chmod o+rwX $(ROOT_DIR)/html
	chmod o+rwX $(ROOT_DIR)/db
.PHONY: setup

count-php-files:
	docker exec $(NAME)_piwik_1 find /var/www/html -iname \*.php|wc -l
.PHONY: count-php-files
