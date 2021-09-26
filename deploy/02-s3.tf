resource "aws_s3_bucket" "app" {
  bucket        = var.app_name
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = var.common_tags
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.app.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": [
        "${aws_s3_bucket.app.arn}/*"
      ]
    }
  ]
}

POLICY
}