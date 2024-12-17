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
  default     = "aaaf99071615c4b6483a131537a8a053-1987626372.us-east-1.elb.amazonaws.com"
}
