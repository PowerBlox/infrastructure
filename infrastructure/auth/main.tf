variable region {}
variable namespace {}
variable cognito_identity_pool_name {}
variable cognito_identity_pool_provider {}

# aws_iam_role.cognito
resource "aws_iam_role" "cognito" {
  name = "${var.namespace}-identity"

  assume_role_policy = "${
    data.template_file.cognito_iam_assume_role_policy.rendered
  }"
}

# aws_cognito_user_pool._
resource "aws_cognito_user_pool" "_" {
  name = "${var.namespace}"

  alias_attributes = [
    "email",
    "preferred_username",
  ]

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable             = false
    required            = true
  }

  lifecycle {
    ignore_changes = ["schema"]
  }
}

# aws_cognito_user_pool_client._
resource "aws_cognito_user_pool_client" "_" {
  name = "${var.namespace}"

  user_pool_id    = "${aws_cognito_user_pool._.id}"
  generate_secret = false

  explicit_auth_flows = [
    "ADMIN_NO_SRP_AUTH",
    "USER_PASSWORD_AUTH",
  ]
}

# aws_cognito_identity_pool._
resource "aws_cognito_identity_pool" "_" {
  identity_pool_name      = "${var.cognito_identity_pool_name}"
  developer_provider_name = "${var.cognito_identity_pool_provider}"

  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = "${aws_cognito_user_pool_client._.id}"
    server_side_token_check = true

    provider_name = "cognito-idp.${
        var.region
      }.amazonaws.com/${
        aws_cognito_user_pool._.id
      }"
  }
}

# aws_cognito_identity_pool_roles_attachment._
resource "aws_cognito_identity_pool_roles_attachment" "_" {
  identity_pool_id = "${aws_cognito_identity_pool._.id}"

  roles {
    "authenticated" = "${aws_iam_role.cognito.arn}"
  }
}
