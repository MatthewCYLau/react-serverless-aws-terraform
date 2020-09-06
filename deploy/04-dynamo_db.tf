resource "aws_dynamodb_table" "dynamodb-table-todos" {
  name             = var.todos_table_name
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "todoId"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "todoId"
    type = "S"
  }
}

resource "aws_dynamodb_table" "dynamodb-table-comments" {
  name             = var.comments_table_name
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "commentId"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "commentId"
    type = "S"
  }
}