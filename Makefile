CURRENT_DIR?=$(abspath .)
INFRASTRUCTURE_DIR=infrastructure

init:
	cd ${INFRASTRUCTURE_DIR} && terraform init

infrastructure: init lambda-readings
	cd ${INFRASTRUCTURE_DIR} && terraform apply

destroy:
	cd ${INFRASTRUCTURE_DIR} && terraform destroy

lambda-readings:
	OUTPUT_DIR="${CURRENT_DIR}/infrastructure" make -C lambda/readings build
