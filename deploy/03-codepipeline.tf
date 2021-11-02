resource "aws_codepipeline" "app" {
  name     = var.app_name
  role_arn = aws_iam_role.codepipeline_role.arn
  depends_on = [
    aws_api_gateway_deployment.app,
    aws_cognito_user_pool.app_user_pool,
    aws_cognito_user_pool_client.app_user_pool_client,
    aws_cognito_identity_pool.app_identity_pool
  ]

  artifact_store {
    location = aws_s3_bucket.www_bucket.bucket
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
        ProjectName = aws_codebuild_project.app.name
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
        BucketName = aws_s3_bucket.www_bucket.bucket
        Extract    = "true"
      }
    }
  }

  stage {
    name = "Invalide-Cloudfront-Cache"

    action {
      name            = "Invalide-Cloudfront-cache"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.invalidate_cache.name
      }
    }
  }
}