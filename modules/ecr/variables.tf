variable "repository_name" {
  description = "Nome do repositório ECR"
  type        = string
}

variable "tags" {
  description = "Tags para o repositório ECR"
  type        = map(any)
}