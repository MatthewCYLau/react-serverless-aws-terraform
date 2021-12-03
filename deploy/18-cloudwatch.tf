resource "aws_cloudwatch_log_group" "process_queue_lambda" {
  name              = "process-queue-function-cloudwatch-log-group"
  retention_in_days = 1

  tags = {
    Environment = var.environment
    Application = var.app_name
  }
}
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${aws_lambda_function.process_queue.function_name}"
  retention_in_days = 1
}

resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
              "${aws_cloudwatch_log_group.process_queue_lambda.arn}*"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logging" {
  role       = aws_iam_role.queue_processer_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}