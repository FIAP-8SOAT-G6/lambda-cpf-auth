data "archive_file" "zip" {
  type        = "zip"
  source_file = "../lambda/hello.js"
  output_path = "../lambda/hello.zip"
}

resource "aws_lambda_function" "hello" {
  filename         = data.archive_file.zip.output_path
  function_name    = "node_js_lambda_authorizer"
  role             = "arn:aws:iam::205225019102:role/LabRole"
  handler          = "hello.handler"
  runtime          = "nodejs18.x"

  # TODO: add to get users from RDS
  # environment {
  #   variables = {
  #     eks_find_by_cpf_endpoint = var.eks_find_by_cpf_endpoint
  #   }
  # }

  source_code_hash = data.archive_file.zip.output_base64sha256
}

resource "aws_lambda_permission" "allow_invoke" {
  statement_id  = "AllowInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello.function_name
  principal     = "*"
}
