DIR ?= App
ENV ?= dev
IMAGE ?= app
COMMAND ?= debug:container
.DEFAULT_GOAL := start
THIS_FILE := $(lastword $(MAKEFILE_LIST))

ENV_COMPOSER = dev
ENV_YARN = ""
ifeq ($(ENV),prod)
 ENV_COMPOSER = no-dev
 ENV_YARN = :prod
endif

#COMPOSER COMMANDS
composer-install:
	docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(IMAGE) bash -c "composer install -d=/app/$(DIR) --$(ENV_COMPOSER)"

composer-update:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(IMAGE) bash -c "composer update -d=/app/$(DIR) --$(ENV_COMPOSER)"

#SYMFONY COMMANDS
create-database:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(IMAGE) bash -c "php /app/$(DIR)/etc/bin/symfony-console doctrine:database:create --if-not-exists"

migrations:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(IMAGE) bash -c "php /app/$(DIR)/etc/bin/symfony-console do:mi:mi -v --no-interaction --allow-no-migration"

cache-clear:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(IMAGE) bash -c "php /app/$(DIR)/etc/bin/symfony-console cache:clear -e $(ENV)"

yarn-install:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(IMAGE) bash -c "cd /app/CompositeUi/src/Infrastructure/Ui/Assets && yarn install && yarn build"

symfony-console:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(IMAGE) bash -c "php /app/$(DIR)/etc/bin/symfony-console $(COMMAND)"

#DOCKER COMMANDS
docker-compose-exec:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(IMAGE) bash -c "$(COMMAND)"

stop:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml down

start:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml down && \
        	docker-compose -f Docker/docker-compose.$(ENV).yaml up -d --remove-orphans

start-hard:
	@rsync --ignore-existing Docker/.env.dist Docker/.env
	        docker-compose -f Docker/docker-compose.$(ENV).yaml down && \
            docker-compose -f Docker/docker-compose.$(ENV).yaml up -d --remove-orphans && \
            $(MAKE) -f $(THIS_FILE) composer-install-all ENV=$(ENV) && \
            $(MAKE) -f $(THIS_FILE) create-database ENV=$(ENV) && \
            $(MAKE) -f $(THIS_FILE) migrations ENV=$(ENV)

deploy:
	@rsync --ignore-existing Docker/.env.dist Docker/.env
	        docker-compose -f Docker/docker-compose.$(ENV).yaml down && \
        	docker-compose -f Docker/docker-compose.$(ENV).yaml build --pull --no-cache && \
            docker-compose -f Docker/docker-compose.$(ENV).yaml up -d --remove-orphans && \
            $(MAKE) -f $(THIS_FILE) composer-install-all ENV=$(ENV) && \
            $(MAKE) -f $(THIS_FILE) create-database ENV=$(ENV) && \
            $(MAKE) -f $(THIS_FILE) migrations ENV=$(ENV) && \
            $(MAKE) -f $(THIS_FILE) yarn-install-and-build ENV=$(ENV)

composer-install-all:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec app bash -c "composer install -d=/app/App --$(ENV_COMPOSER)" && \
        docker-compose -f Docker/docker-compose.$(ENV).yaml exec app bash -c "composer install -d=/app/CompositeUi --$(ENV_COMPOSER)"

docker-connect:
	@docker exec -t -i $(IMAGE) /bin/bash

yarn-install-and-build:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec app bash -c "cd /app/CompositeUi/src/Infrastructure/Ui/Assets && yarn install && yarn build$(YARN_COMPOSER)"

#PREPARATION OF LOCAL ENVIRONMENT
vendor-clear:
	@rm -rf $(DIR)/vendor

clear-all:
	rm -rf App/vendor
	rm -rf App/var/cache
	rm -rf CompositeUi/vendor
	rm -rf CompositeUi/var/cache
	rm -rf CompositeUi/src/Infrastructure/Ui/Assets/node_modules
	rm -rf CompositeUi/src/Infrastructure/Ui/Assets/build
	rm -f App/.lin3s_cs.yml
	rm -f App/parameters.yml
	rm -f App/src/App/Infrastructure/Ui/Http/Symfony/.htaccess
	rm -f App/src/App/Infrastructure/Ui/Http/Symfony/robots.txt
	rm -f CompositeUi/.env
	rm -f CompositeUi/.lin3s_cs.yml
	rm -f CompositeUi/src/Infrastructure/Ui/Http/Symfony/.htaccess
	rm -f CompositeUi/src/Infrastructure/Ui/Http/Symfony/robots.txt

copy-elements:
	cp App/src/App/Infrastructure/Ui/Http/Symfony/.htaccess.dist App/src/App/Infrastructure/Ui/Http/Symfony/.htaccess
	cp App/src/App/Infrastructure/Ui/Http/Symfony/robots.txt.dist App/src/App/Infrastructure/Ui/Http/Symfony/robots.txt
	cp CompositeUi/src/Infrastructure/Ui/Http/Symfony/.htaccess.dist CompositeUi/src/Infrastructure/Ui/Http/Symfony/.htaccess
	cp CompositeUi/src/Infrastructure/Ui/Http/Symfony/robots.txt.dist CompositeUi/src/Infrastructure/Ui/Http/Symfony/robots.txt