resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "nosso-api-gateway" # TODO - Change this name
  description = "API Gateway criado com terraform"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part = "hello"
}

# resource "aws_api_gateway_method" "proxy" {
#   rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
#   resource_id   = aws_api_gateway_resource.proxy.id
#   http_method   = "GET"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "lambda" {
#   rest_api_id = aws_api_gateway_rest_api.api_gateway.id
#   resource_id = aws_api_gateway_method.proxy.resource_id
#   http_method = aws_api_gateway_method.proxy.http_method
#
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.hello.arn}:$${stageVariables.stage}/invocations"
# }
