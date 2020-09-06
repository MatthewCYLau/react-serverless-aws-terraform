resource "aws_api_gateway_rest_api" "react-serverless" {
  name        = "ReactServerless"
  description = "Terraform Serverless Application Example"
  body        = data.template_file.api_definition.rendered

}

output "base_url" {
  value = aws_api_gateway_deployment.api_gateway_deployment.invoke_url
}

data "template_file" "api_definition" {
  template = file("api/openapi.yaml")
  vars = {
    lambda_uri_get_todos         = aws_lambda_function.get_todos.invoke_arn
    lambda_uri_create_todo       = aws_lambda_function.create_todo.invoke_arn
    lambda_uri_get_todo_by_id    = aws_lambda_function.get_todo_by_id.invoke_arn
    lambda_uri_delete_todo_by_id = aws_lambda_function.delete_todo_by_id.invoke_arn
    lambda_uri_create_comment    = aws_lambda_function.create_comment.invoke_arn
  }
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on = [
    aws_api_gateway_rest_api.react-serverless
  ]
  rest_api_id = aws_api_gateway_rest_api.react-serverless.id
  stage_name  = "dev"
}