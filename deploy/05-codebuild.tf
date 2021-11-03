resource "aws_codebuild_project" "app" {
  name          = var.app_name
  description   = var.app_name
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "REACT_APP_API_ENDPOINT"
      value = aws_api_gateway_deployment.app.invoke_url
    }

    environment_variable {
      name  = "REACT_APP_USER_POOL_ID"
      value = aws_cognito_user_pool.app_user_pool.id
    }

    environment_variable {
      name  = "REACT_APP_APP_CLIENT_ID"
      value = aws_cognito_user_pool_client.app_user_pool_client.id
    }

    environment_variable {
      name  = "REACT_APP_IDENTITY_POOL_ID"
      value = aws_cognito_identity_pool.app_identity_pool.id
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "invalidate_cache" {
  name          = "invalidate-cloudfront-cache"
  description   = "Invalidate Cloudfront cache"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_invalidate_cloudfront_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "ROOT_S3_DISTRIBUTION_ID"
      value = aws_cloudfront_distribution.root_s3_distribution.id
    }

    environment_variable {
      name  = "WWW_S3_DISTRIBUTION_ID"
      value = aws_cloudfront_distribution.www_s3_distribution.id
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "deploy/codebuild-buildspecs/invalidate-cloudfront-buildspec.yml"
  }
}