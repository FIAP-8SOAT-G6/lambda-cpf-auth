data "archive_file" "zip" {
  type        = "zip"
  source_file = "../lambda/hello.js"
  output_path = "../lambda/hello.zip"
}

#-> https://github.dev/felipebarras/lambda-authentication/blob/main/.github/workflows/deploy-lambda.yaml
resource "aws_lambda_function" "hello_thawan" {
  filename         = data.archive_file.zip.output_path
  function_name    = "node_js_lambda_authorizer"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "hello_thawan.handler"
  runtime          = "nodejs18.x"

  # environment {
  #   variables = {
  #     eks_find_by_cpf_endpoint = var.eks_find_by_cpf_endpoint
  #   }
  # }

  source_code_hash = data.archive_file.zip.output_base64sha256
}
