
# SQS processer lambda
data "archive_file" "process_queue_zip" {
  type        = "zip"
  source_file = "lambdas/sqsProcesser.js"
  output_path = "lambdas/sqsProcesser.zip"
}

resource "aws_lambda_function" "process_queue" {
  function_name    = "ProcessQueueMessage"
  filename         = data.archive_file.process_queue_zip.output_path
  source_code_hash = data.archive_file.process_queue_zip.output_base64sha256
  handler          = "sqsProcesser.handler"
  runtime          = "nodejs14.x"
  role             = aws_iam_role.queue_processer_lambda.arn

}

resource "aws_iam_role" "queue_processer_lambda" {
  name               = "${var.app_name}-process-queue-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "process_queue_attach" {
  role       = aws_iam_role.queue_processer_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_lambda_event_source_mapping" "map_sqs_queue" {
  event_source_arn = aws_sqs_queue.app_queue.arn
  function_name    = aws_lambda_function.process_queue.arn
}