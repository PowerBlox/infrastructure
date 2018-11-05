# power blox infrastructure setup

this readme covers a basic walk through for the power-blox infrastructure and codebase setup

## requirements

refer to [initial setup document](docs/initial-setup.md) for requirements

after you have installed all requirements, you can simply type:

```bash
make
```

to see the list of available commands

# deploy

## infrastructure

to create / update / destroy the infrastructure, refer to the [terraform](docs/terraform.md) docs, this is configured as follows (all references to folders are relative to `infrastucture`):

- Cognito user pool and client for both user and programmatic authentication, in the `auth` folder
- API Gateway with a single `{proxy+}` resource attached to the Cognito authentication system and relative deployment and DNS records, in the `apigw` folder
- MySQL Database server on RDS with multi-zone availability and automatic daily backup, and DynamoDB NoSQL table with id+sort keys presets, everything in the `db` folder
- two S3 buckets (one for storage and one for logging), in the `storage` folder
- a lambda function with attached roles and policies to gain access to the databases and S3 buckets, in the `api` folder. After updating the code, the new package is created using makefile and deployed via terraform
- a prototype instance on EC2 running node-red and hooked to the [p01.power-blox.cloud](p01.power-blox.cloud) DNS record
- an export file used for the automatic configuration of the frontend, to get access to the correct user pool and client

## database schema & migrations

database schema is defined using [liquibase](https://www.liquibase.org/), its configuration is stored in the `liquibase` folder. When changing the database, a new change set must be defined in the `changeSets` subfolder, then migrations are run.

the liquibase script for database migrations must run from a server that has access to RDS (i.e. within the vpc and/or defined security groups), it's accessible via the makefile

```bash
make migrate
```


## lambda backend

a simple backend is exposed via lambda and authenticated through the API gateway with Cognito. To create a distributable package, just type:

```bash
make lambda-readings
```

the updated package is then deployed running the terraform script described in their specific sections above (via `terraform init`)

## frontend

the frontend is presently published on a S3 bucket [here](http://readings-20181030115713--hostingbucket.s3-website-eu-west-1.amazonaws.com/)

the frontend can be easily published by running

```bash
make publish
```

but for all options offered by [aws amplify](https://aws-amplify.github.io/), cd into `frontend/readings` and type `amplify`
