resource "aws_iam_role" "codebuild_role" {
  name = "${var.app_name}-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild-policy"
  role = aws_iam_role.codebuild_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
       
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ],
            "Resource": [
              "${aws_s3_bucket.www_bucket.arn}/*"
            ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource": [
            "*"
          ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "codebuild_invalidate_cloudfront_role" {
  name = "codebuild-invalidate-cloudfront-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_invalidate_cloudfront_policy" {
  name = "codebuild-invalidate-cloudfront-policy"
  role = aws_iam_role.codebuild_invalidate_cloudfront_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
       
        {
            "Effect": "Allow",
            "Action": [
                "codepipeline:PutJobFailureResult",
                "codepipeline:PutJobSuccessResult",
                "cloudfront:CreateInvalidation"
            ],
            "Resource": [
              "${aws_cloudfront_distribution.www_s3_distribution.arn}", 
              "${aws_cloudfront_distribution.root_s3_distribution.arn}"
            ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource": [
            "*"
          ]
        }
    ]
}
EOF
}