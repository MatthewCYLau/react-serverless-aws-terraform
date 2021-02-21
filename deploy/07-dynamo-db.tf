resource "aws_dynamodb_table" "todos" {
  name             = "todos"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "todoId"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "todoId"
    type = "S"
  }
}

resource "aws_dynamodb_table" "comments" {
  name             = "comments"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "commentId"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "commentId"
    type = "S"
  }

  attribute {
    name = "todoId"
    type = "S"
  }

  global_secondary_index {
    name            = "todoIdIndex"
    hash_key        = "todoId"
    projection_type = "ALL"
  }
}

resource "aws_dynamodb_table" "likes" {
  name             = "likes"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "likeId"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "likeId"
    type = "S"
  }

  attribute {
    name = "commentId"
    type = "S"
  }

  global_secondary_index {
    name            = "commentIdIndex"
    hash_key        = "commentId"
    projection_type = "ALL"
  }
}