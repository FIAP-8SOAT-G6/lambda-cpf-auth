variable "project_name" {
  default = "lambda-cpf-auth"
}

variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "default"
}

variable "lanchonete_api_dns" {
  type        = string
  description = "DNS da Lanchonete API"
}
