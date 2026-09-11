variable "name_prefix" {
  description = "Prefixo usado para nomear os recursos"
  type        = string
}

variable "ami_id" {
  description = "ID da AMI usada na instância EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet onde a instância será criada"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde os recursos serão criados"
  type        = string
}