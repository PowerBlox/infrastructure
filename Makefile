CURRENT_DIR?=$(abspath .)
INFRASTRUCTURE_DIR=infrastructure

help:
	@echo "make, list of available commands (order is important!)"
	@echo "--------------------------------"
	@echo "> lambda-readings:   builds the lambda for deployment"
	@echo "> init:              initialise terraform modules"
	@echo "> plan:              check what needs to be done"
	@echo "> apply:             executes changes"
	@echo "> destroy:           destroys all infrastructure (handle with care!)"

lambda-readings:
	OUTPUT_DIR="${CURRENT_DIR}/infrastructure" make -C lambda/readings build

init:
	cd ${INFRASTRUCTURE_DIR} && terraform init

plan:
	cd ${INFRASTRUCTURE_DIR} && terraform plan

apply:
	cd ${INFRASTRUCTURE_DIR} && terraform apply

destroy:
	cd ${INFRASTRUCTURE_DIR} && terraform destroy
