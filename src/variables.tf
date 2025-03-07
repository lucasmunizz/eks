
variable "aws_region" {
  description = "Região usada para criar os recursos da AWS"
  type        = string
  nullable    = false
}

variable "aws_vpc_name" {
  description = "Nome da VPC"
  type        = string
  nullable    = false
}

variable "aws_vpc_cidr" {
  description = "CIDR"
  type        = string
  nullable    = false
}

variable "aws_vpc_azs" {
  description = "Zonas de disponibilidade"
  type        = set(string)
  nullable    = false
}

variable "aws_vpc_private_subnets" {
  description = "Subnetes privadas"
  type        = set(string)
  nullable    = false
}

variable "aws_vpc_public_subnets" {
  description = "Subnetes públicas"
  type        = set(string)
  nullable    = false
}

variable "aws_eks_name" {
  description = "Nome do cluster eks"
  type        = string
  nullable    = false
}

variable "aws_eks_version" {
  description = "Versão do cluster EKS"
  type        = string
  nullable    = false
}

variable "aws_eks_managed_node_groups_instance_types" {
  description = "Tipo de instancia dos nós do EKS"
  type        = set(string)
  nullable    = false
}

variable "aws_project_tags" {
  description = "Tags do projeto"
  type        = map(any)
  nullable    = false
}