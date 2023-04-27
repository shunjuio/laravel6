.DEFAULT_GOAL := help

build: ## build develoment environment
	if ! [ -f .env ];then cp .env.example .env;fi
	docker-compose build
	docker-compose run --rm php composer install
	docker-compose run --rm php php artisan key:generate
	docker-compose run --rm php php artisan migrate
	docker-compose run --rm php php artisan db:seed
	docker-compose run --rm php php artisan ide-helper:generate
	docker-compose run --rm php php artisan ide-helper:meta
	docker-compose run --rm npm npm install
	docker-compose run --rm npm gulp

serve: ## Run Server
	docker-compose up php

migrate: ## Run migrate
	docker-compose run --rm php php artisan migrate

tinker: ## Run tinker
	docker-compose run --rm php php artisan tinker

composer: ## Entry for Composer command
	docker-compose run --rm php composer install

db-log: ## Tail mariadb log
	docker-compose exec db tail -f /var/lib/mysql/logs/general.log

gulp: ## Run gulp
	docker-compose run --rm npm gulp

gulp-watch: ## Run gulp watche
	docker-compose run --rm npm gulp watch

seeder: ## Run db seed
	docker-compose run --rm php php artisan db:seed
	docker-compose run --rm php php artisan db:seed --class=MakeUsersSeeder
	# docker-compose run --rm php php artisan db:seed --class=UserTallyMakeSeeder
	docker-compose run --rm php php artisan db:seed --class=UpdateAllUsersMailAlerts
	docker-compose run --rm php php artisan db:seed --class=DemoFullDataSeeder

phpstan:
	docker-compose run --rm php ./vendor/bin/phpstan analyse

graphql-schema: ## Print schema.graphql
	docker-compose run --rm php php artisan lighthouse:print-schema > graphql/schema.graphql

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
