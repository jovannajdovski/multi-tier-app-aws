
resource "aws_dynamodb_table" "dynamodb-table" {
  name         = var.dynamo_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
  tags = {
    Name        = "dynamodb-table-items"
  }
}