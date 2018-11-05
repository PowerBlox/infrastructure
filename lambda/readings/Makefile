OUTPUT_DIR?=$(abspath .)
OUTPUT_FILE?=lambda-readings.zip
DELIVERABLE="${OUTPUT_DIR}/${OUTPUT_FILE}"

build:
	zip -r9 ${DELIVERABLE} . -x *__pycache__* *.pyc* test-reports/*

install:
	pipenv install

clean:
	rm -f ${DELIVERABLE}
	pipenv --rm

libs:
	pipenv sync --dev
	$(eval VENV = $(shell pipenv --venv))
	# excluding a bunch of packages here so we can stay within 50mb
	cd ${VENV}/lib/python3.6/site-packages && zip -r9 ${DELIVERABLE} ./* -x *__pycache__* *.pyc* boto*/**\* pip*/**\* pylint*/**\* pytest*/**\* rope*/**\* setuptools*/**\*

all: build libs
	@echo "build with libs"

build_with_docker:
	docker run --rm -v `pwd`:/code -v ${HOME}/.ssh:/home/circleci/.ssh circleci/python:3.6.4 bash -c 'cd /code && make all'
