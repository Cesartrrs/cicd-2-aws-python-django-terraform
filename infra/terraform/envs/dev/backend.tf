terraform {
  backend "s3" {
    bucket         = "cicd-2-aws-python-django-tfstate-897722677427"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "cicd-2-aws-python-django-tflock"
    encrypt        = true
  }
}
