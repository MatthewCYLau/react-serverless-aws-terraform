resource "aws_iam_role" "apig_sqs_send_msg" {
  name               = "${var.app_name}-apig-sqs-send-msg-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "apig_policy" {
  name = "${var.app_name}-apig-sqs-send-msg-policy"
  role = aws_iam_role.apig_sqs_send_msg.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sqs:SendMessage",
            "Resource": [
                "${aws_sqs_queue.app_queue.arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "apig_attach" {
  role       = aws_iam_role.apig_sqs_send_msg.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}