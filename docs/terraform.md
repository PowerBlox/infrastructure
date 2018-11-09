# Terraform

assuming terraform is installed, as described in the [initial setup](./initial-setup.md) document, you want to initialise it first, then run the changes

```bash
# initialise terraform modules
terraform init
# show what needs to change without doing anything
terraform plan
# apply the changes
terraform apply
```

then if you want to burn everything down and restart from scratch (handle with care! :warning: :bomb:)

```bash
terraform destroy
```
