resource "aws_cognito_user_pool" "app_user_pool" {
  name                     = "react_serverless_aws_terraform_user_pool"
  alias_attributes         = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length                   = 6
    require_lowercase                = false
    require_numbers                  = false
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 7
  }
  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "email"
    required            = true
  }

  lifecycle {
    ignore_changes = [
      schema ### AWS doesn't allow schema updates, so every build will re-create the user pool unless we ignore this bit
    ]
  }
}

resource "aws_cognito_user_pool_client" "app_user_pool_client" {
  name = "react_serverless_aws_terraform_user_pool_client"

  user_pool_id = aws_cognito_user_pool.app_user_pool.id

  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_identity_pool" "app_identity_pool" {
  identity_pool_name               = "react_serverless_aws_terraform_identity_pool"
  allow_unauthenticated_identities = false
  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.app_user_pool_client.id
    provider_name           = aws_cognito_user_pool.app_user_pool.endpoint
    server_side_token_check = false
  }
}

resource "aws_iam_role" "id_pool_authenticated_role" {
  name = "cognito_authenticated"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.app_identity_pool.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "id_pool_authenticated_role_policy" {
  name = "authenticated_policy"
  role = aws_iam_role.id_pool_authenticated_role.id
  depends_on = [
    aws_api_gateway_deployment.app
  ]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "execute-api:Invoke"
      ],
      "Resource": [
        "${aws_api_gateway_rest_api.app.execution_arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_cognito_identity_pool_roles_attachment" "id_pool_roles_attachment" {
  identity_pool_id = aws_cognito_identity_pool.app_identity_pool.id

  roles = {
    "authenticated" = aws_iam_role.id_pool_authenticated_role.arn
  }
}

