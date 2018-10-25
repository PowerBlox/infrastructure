# initial setup

## requirements

you need to have

- terraform
- python 3.6+ installed with pipenv

e.g. if you're using mac:

```shell
brew install terraform python3
pip3 install pipenv
```

you can then cd to this repo's root, create a virtual environment and install dependencies by running

```shell
cd $GIT_ROOT
pipenv install
```

you're now ready to configure your aws profile

## aws profile

make sure you have an AWS keypair to configure your profile for cloud access, if you don't have one, ask your system administrator. When you have your secrets, you are ready to configure your profile for programmatic access by running:

```shell
pipenv run aws configure --profile power-blox
# the following will be prompted during the configuration, make sure everything matches
> AWS Access Key ID [None]: YOUR_ACCESS_KEY
> AWS Secret Access Key [None]: YOUR_SECRET_KEY
> Default region name [None]: eu-west-1
> Default output format [None]: json
```
