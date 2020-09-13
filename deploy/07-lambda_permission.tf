resource "aws_lambda_permission" "lambda_permission_get_todos" {
  statement_id  = "AllowExecutionFromAPIGatewayUCI"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_todos.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.react-serverless.execution_arn}/*/GET/todos"
}

resource "aws_lambda_permission" "lambda_permission_get_todo_by_id" {
  statement_id  = "AllowExecutionFromAPIGatewayUCI"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_todo_by_id.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.react-serverless.execution_arn}/*/GET/todos/*"
}

resource "aws_lambda_permission" "lambda_permission_delete_todo_by_id" {
  statement_id  = "AllowExecutionFromAPIGatewayUCI"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_todo_by_id.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.react-serverless.execution_arn}/*/DELETE/todos/*"
}

resource "aws_lambda_permission" "lambda_permission_create_todo" {
  statement_id  = "AllowExecutionFromAPIGatewayUCI"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_todo.function_name
  principal     = "apigateway.amazonaws.com"
  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.react-serverless.execution_arn}/*/POST/todos"
}

resource "aws_lambda_permission" "lambda_permission_create_comment" {
  statement_id  = "AllowExecutionFromAPIGatewayUCI"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_comment.function_name
  principal     = "apigateway.amazonaws.com"
  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.react-serverless.execution_arn}/*/POST/comments"
}

resource "aws_lambda_permission" "lambda_permission_get_comments" {
  statement_id  = "AllowExecutionFromAPIGatewayUCI"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_comments.function_name
  principal     = "apigateway.amazonaws.com"
  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.react-serverless.execution_arn}/*/GET/comments"
}