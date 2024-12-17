data "archive_file" "hello_zip" {
  type        = "zip"
  source_file = "../lambda/hello.js"
  output_path = "../lambda/hello.zip"
}

variable "lambda_role_arn" {
  description = "IAM Role ARN for Lambda"
  type        = string
}

resource "aws_lambda_function" "hello" {
  filename         = data.archive_file.hello_zip.output_path
  function_name    = "lambda_hello"
  role             = var.lambda_role_arn
  handler          = "hello.handler"
  runtime          = "nodejs18.x"

  source_code_hash = data.archive_file.hello_zip.output_base64sha256
}

resource "aws_lambda_permission" "allow_api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}
