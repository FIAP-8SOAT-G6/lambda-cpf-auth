resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "tech-challenge-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api_gateway.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.auth.invoke_arn
  payload_format_version = "2.0"
}

# intregation with validate-cpf lambda function
resource "aws_apigatewayv2_integration" "validate_cpf_lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api_gateway.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.validate_cpf.invoke_arn
  payload_format_version = "2.0"
}

# lambda_authorizer
resource "aws_lambda_permission" "lambda_authorizer_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_authorizer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

resource "aws_apigatewayv2_authorizer" "gateway_lambda_authorizer" {
  api_id                            = aws_apigatewayv2_api.api_gateway.id
  name                              = "lambda-authorizer"
  authorizer_type                   = "REQUEST"
  authorizer_uri                    = aws_lambda_function.lambda_authorizer.invoke_arn
  identity_sources                  = ["$request.header.Authorization"]
  authorizer_result_ttl_in_seconds  = 300
  authorizer_payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "eks_api_integration" {
  api_id                 = aws_apigatewayv2_api.api_gateway.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = "http://${var.lanchonete_api_dns}/{proxy}"
  payload_format_version = "1.0"
}

# Rota do lambda gerador do auth token
resource "aws_apigatewayv2_route" "lambda_route" {
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "GET /lambda"
  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Rota do lambda validate-cpf
resource "aws_apigatewayv2_route" "validate_cpf_lambda_route" {
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "POST /validate_cpf"
  target             = "integrations/${aws_apigatewayv2_integration.validate_cpf_lambda_integration.id}"
}

# Rota do eks
resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.eks_api_integration.id}"
}

# Stages
resource "aws_apigatewayv2_stage" "dev_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "dev"
  auto_deploy = true
}

resource "aws_apigatewayv2_stage" "prod_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "prod"
  auto_deploy = true
}
