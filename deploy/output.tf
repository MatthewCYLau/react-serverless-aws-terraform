output "app_url" {
  description = "The website end-point of the S3 bucket"
  value       = aws_s3_bucket.www_bucket.website_endpoint
}

output "api_base_url" {
  value = aws_api_gateway_deployment.app.invoke_url
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