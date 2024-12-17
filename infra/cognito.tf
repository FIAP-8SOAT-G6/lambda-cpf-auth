resource "aws_cognito_user_pool" "pool" {
  name = "mypool"
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain      = "vitor-tech-challenge-fiap"
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_client" "client" {
  name = "client"
  allowed_oauth_flows_user_pool_client = true
  generate_secret = false
  allowed_oauth_scopes = ["aws.cognito.signin.user.admin","email", "openid", "profile"]
  allowed_oauth_flows = ["implicit", "code"]
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  supported_identity_providers = ["COGNITO"]

  user_pool_id = aws_cognito_user_pool.pool.id
  callback_urls = ["https://${aws_apigatewayv2_api.api_gateway.id}.execute-api.${var.region}.amazonaws.com/${aws_apigatewayv2_stage.dev_stage.name}/lambda"]
  logout_urls = ["https://foo.com"]
}

resource "aws_cognito_user" "admin" {
  user_pool_id = aws_cognito_user_pool.pool.id
  username = "Admin"
  password = "Admin@123"
}
