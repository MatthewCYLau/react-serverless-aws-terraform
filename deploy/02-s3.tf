resource "aws_s3_bucket" "www_bucket" {
  bucket        = "www.${var.bucket_name}"
  acl           = "public-read"
  policy        = templatefile("policy/s3-policy.json", { bucket = "www.${var.bucket_name}" })
  force_destroy = true

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = var.common_tags
}

# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "root_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = templatefile("policy/s3-policy.json", { bucket = var.bucket_name })

  website {
    redirect_all_requests_to = "https://www.${var.domain_name}"
  }

  tags = var.common_tags
}

# resource "aws_s3_bucket_policy" "this" {
#   bucket = aws_s3_bucket.www_bucket.id
#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "PublicReadGetObject",
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": "s3:GetObject",
#       "Resource": [
#         "${aws_s3_bucket.www_bucket.arn}/*"
#       ]
#     }
#   ]
# }

# POLICY
# }