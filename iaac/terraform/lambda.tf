data "archive_file" "lambda_delete" {
  type = "zip"
  source_file = "../code/lambda_delete.py"
  output_path = "../code/archives/lambda_delete.zip"
}

data "archive_file" "lambda_get" {
  type = "zip"
  source_file = "../code/lambda_get.py"
  output_path = "../code/archives/lambda_get.zip"
}

data "archive_file" "lambda_getAll" {
  type = "zip"
  source_file = "../code/lambda_getAll.py"
  output_path = "../code/archives/lambda_getAll.zip"
}

data "archive_file" "lambda_post" {
  type = "zip"
  source_file = "../code/lambda_post.py"
  output_path = "../code/archives/lambda_post.zip"
}

data "archive_file" "lambda_put" {
  type = "zip"
  source_file = "../code/lambda_put.py"
  output_path = "../code/archives/lambda_put.zip"
}

# LAMBDA ROLE

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
    {
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }
  ]
})
}

resource "aws_iam_policy" "function_logging_policy" {
  name   = "function-logging-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "function_logging_policy_attachment" {
  role = aws_iam_role.lambda_role.id
  policy_arn = aws_iam_policy.function_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_dynamo" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role = aws_iam_role.lambda_role.name
}

# DELETE

resource "aws_lambda_function" "delete_lambda" {
  filename = "../code/archives/lambda_delete.zip"
  function_name = "delete_function"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_delete.lambda_handler"
  runtime = "python3.9"
  source_code_hash = data.archive_file.lambda_delete.output_base64sha256
  environment {
    variables = {
      TableName = var.dynamo_table_name
    }
  }
}

resource "aws_lambda_permission" "apigw_lambda_delete" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_lambda.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.praksa_api.execution_arn}/*/*/*"
}

resource "aws_cloudwatch_log_group" "function_delete_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.delete_lambda.function_name}"
  retention_in_days = 7
}


# GET

resource "aws_lambda_function" "get_lambda" {
  filename = "../code/archives/lambda_get.zip"
  function_name = "get_function"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_get.lambda_handler"
  runtime = "python3.9"
  source_code_hash = data.archive_file.lambda_get.output_base64sha256
  environment {
    variables = {
      TableName = var.dynamo_table_name
    }
  }
}

resource "aws_lambda_permission" "apigw_lambda_get" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_lambda.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.praksa_api.execution_arn}/*/*/*"
}

resource "aws_cloudwatch_log_group" "function_get_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.get_lambda.function_name}"
  retention_in_days = 7
}

# GET ALL

resource "aws_lambda_function" "getAll_lambda" {
  filename = "../code/archives/lambda_getAll.zip"
  function_name = "getAll_function"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_getAll.lambda_handler"
  runtime = "python3.9"
  source_code_hash = data.archive_file.lambda_getAll.output_base64sha256
  environment {
    variables = {
      TableName = var.dynamo_table_name
    }
  }
}

resource "aws_lambda_permission" "apigw_lambda_getAll" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getAll_lambda.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.praksa_api.execution_arn}/*/GET/items"
}

resource "aws_cloudwatch_log_group" "function_getAll_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.getAll_lambda.function_name}"
  retention_in_days = 7
}

# POST

resource "aws_lambda_function" "post_lambda" {
  filename = "../code/archives/lambda_post.zip"
  function_name = "post_function"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_post.lambda_handler"
  runtime = "python3.9"
  source_code_hash = data.archive_file.lambda_post.output_base64sha256
  environment {
    variables = {
      TableName = var.dynamo_table_name
    }
  }
}

resource "aws_lambda_permission" "apigw_lambda_post" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_lambda.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.praksa_api.execution_arn}/*/*/*"
}

resource "aws_cloudwatch_log_group" "function_post_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.post_lambda.function_name}"
  retention_in_days = 7
}


# PUT

resource "aws_lambda_function" "put_lambda" {
  filename = "../code/archives/lambda_put.zip"
  function_name = "put_function"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_put.lambda_handler"
  runtime = "python3.9"
  source_code_hash = data.archive_file.lambda_put.output_base64sha256
  environment {
    variables = {
      TableName = var.dynamo_table_name
    }
  }
}

resource "aws_lambda_permission" "apigw_lambda_put" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.put_lambda.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.praksa_api.execution_arn}/*/*/*"
}

resource "aws_cloudwatch_log_group" "function_put_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.put_lambda.function_name}"
  retention_in_days = 7
}
