resource "aws_api_gateway_rest_api" "praksa_api" {
  name = var.api_gateway_name
  description = "API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# resource /items

resource "aws_api_gateway_resource" "items_resource" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  parent_id = aws_api_gateway_rest_api.praksa_api.root_resource_id
  path_part = "items"
}

# resource /items/{id}

resource "aws_api_gateway_resource" "item_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  parent_id = aws_api_gateway_resource.items_resource.id
  path_part = "{id}"
}

# /items POST

resource "aws_api_gateway_method" "proxy_post" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration_post" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_method.proxy_post.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.post_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy_post" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_method.proxy_post.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "proxy_post" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_method.proxy_post.http_method
  status_code = aws_api_gateway_method_response.proxy_post.status_code

  depends_on = [
    aws_api_gateway_method.proxy_post,
    aws_api_gateway_integration.lambda_integration_post
  ]
}

# /items GET (ALL)

resource "aws_api_gateway_method" "proxy_get_all" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration_get_all" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_method.proxy_get_all.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.getAll_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy_get_all" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_method.proxy_get_all.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "proxy_get_all" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_method.proxy_get_all.http_method
  status_code = aws_api_gateway_method_response.proxy_get_all.status_code

  depends_on = [
    aws_api_gateway_method.proxy_get_all,
    aws_api_gateway_integration.lambda_integration_get_all
  ]
}

# /items OPTIONS

resource "aws_api_gateway_method" "proxy_options" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration_options" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method   = aws_api_gateway_method.proxy_options.http_method
  type          = "MOCK"

  request_templates = {
    "application/json" = <<EOF
      {"statusCode": 200}
    EOF
  }
}

resource "aws_api_gateway_method_response" "proxy_options" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method   = aws_api_gateway_method.proxy_options.http_method
  status_code   = "200"
}

resource "aws_api_gateway_integration_response" "proxy_options" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method   = aws_api_gateway_method.proxy_options.http_method
  status_code   = aws_api_gateway_method_response.proxy_options.status_code
  depends_on = [
    aws_api_gateway_method.proxy_options,
    aws_api_gateway_integration.integration_options
  ]
}

# /items/{id} GET

resource "aws_api_gateway_method" "proxy_get_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration_get_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method = aws_api_gateway_method.proxy_get_id.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.get_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy_get_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method = aws_api_gateway_method.proxy_get_id.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "proxy_get_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method = aws_api_gateway_method.proxy_get_id.http_method
  status_code = aws_api_gateway_method_response.proxy_get_id.status_code

  depends_on = [
    aws_api_gateway_method.proxy_get_id,
    aws_api_gateway_integration.lambda_integration_get_id
  ]
}

# /items/{id} PUT

resource "aws_api_gateway_method" "proxy_put_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration_put_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method = aws_api_gateway_method.proxy_put_id.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.put_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy_put_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method = aws_api_gateway_method.proxy_put_id.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "proxy_put_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method = aws_api_gateway_method.proxy_put_id.http_method
  status_code = aws_api_gateway_method_response.proxy_put_id.status_code

  depends_on = [
    aws_api_gateway_method.proxy_put_id,
    aws_api_gateway_integration.lambda_integration_put_id
  ]
}


# /items/{id} DELETE

resource "aws_api_gateway_method" "proxy_delete_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration_delete_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method = aws_api_gateway_method.proxy_delete_id.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.delete_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy_delete_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method = aws_api_gateway_method.proxy_delete_id.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "proxy_delete_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method = aws_api_gateway_method.proxy_delete_id.http_method
  status_code = aws_api_gateway_method_response.proxy_delete_id.status_code

  depends_on = [
    aws_api_gateway_method.proxy_delete_id,
    aws_api_gateway_integration.lambda_integration_delete_id
  ]
}

# /items/{id} OPTIONS

resource "aws_api_gateway_method" "proxy_options_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration_options_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method   = aws_api_gateway_method.proxy_options_id.http_method
  type          = "MOCK"

  request_templates = {
    "application/json" = <<EOF
      {"statusCode": 200}
    EOF
  }
}

resource "aws_api_gateway_method_response" "proxy_options_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method   = aws_api_gateway_method.proxy_options_id.http_method
  status_code   = "200"
}

resource "aws_api_gateway_integration_response" "proxy_options_id" {
  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  resource_id = aws_api_gateway_resource.item_id_resource.id
  http_method   = aws_api_gateway_method.proxy_options_id.http_method
  status_code   = aws_api_gateway_method_response.proxy_options_id.status_code
  depends_on = [
    aws_api_gateway_method.proxy_options_id,
    aws_api_gateway_integration.integration_options_id
  ]
}


# deployment stage

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration_post,
    aws_api_gateway_integration.lambda_integration_get_all,
    aws_api_gateway_integration.lambda_integration_get_id,
    aws_api_gateway_integration.lambda_integration_put_id,
    aws_api_gateway_integration.lambda_integration_delete_id
  ]

  rest_api_id = aws_api_gateway_rest_api.praksa_api.id
  stage_name = "dev"
}


# custom domain name for api gateway

resource "aws_api_gateway_domain_name" "api_domain" {
  domain_name              = "api.devopspraksans2024.com"
  regional_certificate_arn = aws_acm_certificate_validation.validation_records.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "api_domain_mapping" {
  api_id      = aws_api_gateway_rest_api.praksa_api.id
  stage_name  = aws_api_gateway_deployment.deployment.stage_name
  domain_name = aws_api_gateway_domain_name.api_domain.domain_name
}
