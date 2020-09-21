resource "aws_cognito_user_pool" "app_user_pool" {
  name = "react_serverless_aws_terraform_user_pool"
  # ATTRIBUTES
  alias_attributes         = ["email"]
  auto_verified_attributes = ["email"]

  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "email"
    required            = true
  }
}

resource "aws_cognito_user_pool_client" "app_user_pool_client" {
  name = "react_serverless_aws_terraform_user_pool_client"

  user_pool_id = aws_cognito_user_pool.app_user_pool.id

  # APP INTEGRATION
  supported_identity_providers         = ["COGNITO"]
  callback_urls                        = ["https://www.example.com"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
}

# TO-DO remove domain?
resource "aws_cognito_user_pool_domain" "app_user_pool_domain" {
  domain       = "react-serverless-terraform"
  user_pool_id = aws_cognito_user_pool.app_user_pool.id
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
        "arn:aws:execute-api:us-east-1:*:iqx8648fl1/*"
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

output "user_pool_id" {
  value = aws_cognito_user_pool.app_user_pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.app_user_pool_client.id
}

output "identity_pool_id" {
  value = aws_cognito_identity_pool.app_identity_pool.id
}