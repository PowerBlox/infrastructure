CURRENT_DIR=$(abspath .)
OUTPUT_DIR?=${CURRENT_DIR}
OUTPUT_FILE?=lambda-readings.zip
DELIVERABLE="${OUTPUT_DIR}/${OUTPUT_FILE}"

build:
	zip -r9 ${DELIVERABLE} ./* .env -x *__pycache__* *.pyc* test-reports/*

install:
	pipenv install

clean:
	rm -f ${DELIVERABLE}
	pipenv --rm

libs:
	pipenv sync --dev
	$(eval VENV=$(shell pipenv --venv))
	cd ${VENV}/lib/python3.6/site-packages && zip -r9 ${DELIVERABLE} ./* -x *__pycache__* *.pyc* awscli*/**\* boto*/**\* pip*/**\* pylint*/**\* pytest*/**\* setuptools*/**\*

all: libs build
	@echo "build with libs"

build_with_docker:
	cp ${CURRENT_DIR}/../../Pipfile* .
	docker run --rm -v ${CURRENT_DIR}:/code -v ${HOME}/.ssh:/home/circleci/.ssh circleci/python:3.6.4 bash -c 'cd /code && make install && make all'
	rm -f ${CURRENT_DIR}/Pipfile*
	-mv -f ${DELIVERABLE} ${CURRENT_DIR}/../../infrastructure
