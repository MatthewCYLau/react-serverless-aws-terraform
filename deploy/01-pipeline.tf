provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "react-serverless-s3-bucket" {
  bucket        = var.bucket_name
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.react-serverless-s3-bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    }
  ]
}

POLICY
}

resource "aws_codepipeline" "react-serverless-codepipeline" {
  name     = "react-serverless-codepipeline"
  role_arn = aws_iam_role.react_serverless_codepipeline_role.arn
  depends_on = [
    aws_api_gateway_deployment.api_gateway_deployment,
    aws_cognito_user_pool.app_user_pool,
    aws_cognito_user_pool_client.app_user_pool_client,
    aws_cognito_identity_pool.app_identity_pool
  ]

  artifact_store {
    location = aws_s3_bucket.react-serverless-s3-bucket.bucket
    type     = "S3"

  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_username
        Repo       = var.github_project_name
        Branch     = "master"
        OAuthToken = var.github_token
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "react-serverless-codebuild"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        BucketName = aws_s3_bucket.react-serverless-s3-bucket.bucket
        Extract    = "true"
      }
    }
  }
}

resource "aws_codebuild_project" "react-serverless-codebuild" {
  name          = "react-serverless-codebuild"
  description   = "react-serverless-codebuild"
  build_timeout = "5"
  service_role  = aws_iam_role.react_serverless_codebuild_role.arn

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
      value = aws_api_gateway_deployment.api_gateway_deployment.invoke_url
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