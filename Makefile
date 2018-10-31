CURRENT_DIR?=$(abspath .)
INFRASTRUCTURE_DIR=infrastructure

help:
	@echo "make, list of available commands (order is important!)"
	@echo "--------------------------------"
	@echo "> lambda-readings:   builds the lambda for deployment"
	@echo "> init:              initialise terraform modules"
	@echo "> infrastructure:    builds with terraform"
	@echo "> destroy:           destroys with terraform (handle with care!)"

lambda-readings:
	OUTPUT_DIR="${CURRENT_DIR}/infrastructure" make -C lambda/readings build

init:
	cd ${INFRASTRUCTURE_DIR} && terraform init

infrastructure:
	cd ${INFRASTRUCTURE_DIR} && terraform apply

destroy:
	cd ${INFRASTRUCTURE_DIR} && terraform destroy
