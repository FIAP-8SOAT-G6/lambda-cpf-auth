data "archive_file" "zip" {
  type        = "zip"
  source_file = "../lambda/hello.js"
  output_path = "../lambda/hello.zip"
}

resource "aws_lambda_function" "hello_thawan" {
  filename         = data.archive_file.zip.output_path
  function_name    = "node_js_lambda_authorizer"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "hello_thawan.handler"
  runtime          = "nodejs18.x"

  # TODO: add to get users from RDS
  # environment {
  #   variables = {
  #     eks_find_by_cpf_endpoint = var.eks_find_by_cpf_endpoint
  #   }
  # }

  source_code_hash = data.archive_file.zip.output_base64sha256
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_thawan.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}
