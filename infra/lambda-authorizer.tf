data "archive_file" "authorizer_zip" {
  type        = "zip"
  source_dir = "lambda-authorizer"
  output_path = "lambda-authorizer.zip"
}

resource "aws_lambda_function" "lambda_authorizer" {
  filename         = data.archive_file.authorizer_zip.output_path
  function_name    = "node_js_lambda_authorizer"
  role             = var.lambda_role_arn
  handler          = "lambda-authorizer.handler"
  runtime          = "nodejs18.x"

  # TODO: add to get users from RDS
  # environment {
  #   variables = {
  #     eks_find_by_cpf_endpoint = var.eks_find_by_cpf_endpoint
  #   }
  # }

  source_code_hash = data.archive_file.authorizer_zip.output_base64sha256
}
