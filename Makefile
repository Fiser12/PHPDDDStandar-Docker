DIR ?= App
ENV ?= dev
SERVICE ?= app-$(ENV)
IMAGE ?= symfony-app-$(ENV)

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
	docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(SERVICE) bash -c "composer install -d=/app/$(DIR) --$(ENV_COMPOSER)"

composer-update:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(SERVICE) bash -c "composer update -d=/app/$(DIR) --$(ENV_COMPOSER)"

#SYMFONY COMMANDS
create-database:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(SERVICE) bash -c "php /app/$(DIR)/etc/bin/symfony-console doctrine:database:create --if-not-exists"

migrations:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(SERVICE) bash -c "php /app/$(DIR)/etc/bin/symfony-console do:mi:mi -v --no-interaction --allow-no-migration"

cache-clear:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(SERVICE) bash -c "php /app/$(DIR)/etc/bin/symfony-console cache:clear -e $(ENV)"

symfony-console:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(SERVICE) bash -c "php /app/$(DIR)/etc/bin/symfony-console $(COMMAND)"

yarn-install-and-build:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec app-$(ENV) bash -c "cd /app/CompositeUi/src/Infrastructure/Ui/Assets && yarn install && yarn build$(YARN_COMPOSER)"

#DOCKER COMMANDS
docker-compose-exec:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec $(SERVICE) bash -c "$(COMMAND)"

stop:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml down

start:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml down && \
        	docker-compose -f Docker/docker-compose.$(ENV).yaml up -d

build:
	@rsync --ignore-existing Docker/.env.dist Docker/.env && \
	        chmod -R 777 App/var CompositeUi/var && \
	        docker-compose -f Docker/docker-compose.$(ENV).yaml down && \
        	docker-compose -f Docker/docker-compose.$(ENV).yaml build --pull --no-cache && \
            docker-compose -f Docker/docker-compose.$(ENV).yaml up -d

composer-install-all:
	@docker-compose -f Docker/docker-compose.$(ENV).yaml exec app-$(ENV) bash -c "composer install -d=/app/App --$(ENV_COMPOSER)" && \
        docker-compose -f Docker/docker-compose.$(ENV).yaml exec app-$(ENV) bash -c "composer install -d=/app/CompositeUi --$(ENV_COMPOSER)"

docker-connect:
	@docker exec -t -i $(IMAGE) /bin/bash