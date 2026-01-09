variable "project" { default = "cicd-2-aws-python-django" }

variable "vpc_cidr" { default = "10.20.0.0/16" }

variable "public_subnets" {
  type    = list(string)
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "ecr_repository_name" {
  default = "cicd-2-aws-python-django"  # <-- tu repo ECR nuevo (exacto)
}

variable "image_tag" { default = "latest" }

variable "container_port" { default = 8000 }
variable "task_cpu"       { default = 256 }
variable "task_memory"    { default = 512 }
variable "desired_count"  { default = 1 }
