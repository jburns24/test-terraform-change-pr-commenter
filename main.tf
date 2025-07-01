# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.6.0"
}

provider "aws" {
  # Uses AWS credentials & region from your environment (e.g. AWS_PROFILE / AWS_ACCESS_KEY_ID).
  region = var.aws_region
}



variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  # By omitting subnet_id/security_group_ids, Terraform uses the default VPC,
  # its default subnet for the chosen region, and the default security group.
  tags = {
    Name = "tf-t2-micro"
  }
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
