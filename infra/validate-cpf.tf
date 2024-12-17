data "archive_file" "validate_cpf_lambda_auth_zip" {
  type        = "zip"
  source_dir = "../validate-cpf"
  output_path = "../validate-cpf/validate-cpf.zip"
}

resource "aws_lambda_function" "validate_cpf" {
  filename         = data.archive_file.validate_cpf_lambda_auth_zip.output_path
  function_name    = "validate_cpf"
  role             = data.aws_iam_role.labrole.arn
  handler          = "validate_cpf.lambda_handler"
  runtime          = "ruby3.2"

  #environment {
  #  variables = {
  #    API_GATEWAY_URL = output.api_gateway_url
  #  }
  #}

  source_code_hash = data.archive_file.validate_cpf_lambda_auth_zip.output_base64sha256
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_validate_cpf" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.validate_cpf.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}
