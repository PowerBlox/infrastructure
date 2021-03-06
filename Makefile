CURRENT_DIR?=$(abspath .)
INFRASTRUCTURE_DIR=infrastructure
FRONTEND_DIR=frontend/readings

help:
	@echo "make, list of available commands (order is important!)"
	@echo "--------------------------------"
	@echo "> lambda-readings:   builds the lambda for deployment"
	@echo "> publish:           publishes the frontend"
	@echo "> migrate:           run database migrations"
	@echo "> init:              initialise terraform modules"
	@echo "> plan:              check what needs to be done"
	@echo "> apply:             executes changes"
	@echo "> destroy:           destroys all infrastructure (handle with care!)"

lambda-readings:
	# ------------------------------------------------
	# use the following if building on a linux system
	# OUTPUT_DIR="${CURRENT_DIR}/infrastructure" make -C lambda/readings all
	# ------------------------------------------------
	# use the following if building on any other system
	make -C lambda/readings build_with_docker

publish:
	cd ${FRONTEND_DIR} && amplify publish

migrate:
	./script/liquibase.sh update

init:
	cd ${INFRASTRUCTURE_DIR} && terraform init

plan:
	cd ${INFRASTRUCTURE_DIR} && terraform plan

apply:
	cd ${INFRASTRUCTURE_DIR} && terraform apply

destroy:
	cd ${INFRASTRUCTURE_DIR} && terraform destroy
