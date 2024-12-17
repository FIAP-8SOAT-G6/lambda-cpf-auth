data "archive_file" "lambda_auth_zip" {
  type        = "zip"
  source_dir = "../cpf-auth"
  output_path = "../cpf-auth/cpf-auth.zip"
}

data "aws_iam_role" "labrole" {
  name = "LabRole"
}

resource "aws_lambda_function" "auth" {
  filename         = data.archive_file.lambda_auth_zip.output_path
  function_name    = "cpf-auth"
  role             = data.aws_iam_role.labrole.arn
  handler          = "cpf-auth.handler"
  runtime          = "nodejs18.x"

  source_code_hash = data.archive_file.lambda_auth_zip.output_base64sha256
}

resource "aws_lambda_permission" "allow_api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}
