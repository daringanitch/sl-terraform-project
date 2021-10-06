terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "sl-terraform"
  region  = "us-east-1"
}

resource "aws_instance" "sl-appserver" {
  ami                    = "ami-05d7cb15bfbf13b6d"
  instance_type          = "t2.micro"
  key_name               = "infra-key"
  vpc_security_group_ids = [aws_security_group.app-sg.name]
  tags = {
    Name = "sl-appserver"
  }
}

resource "aws_security_group" "app-sg" {
  name = "sl-terraform-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sl-terraform-sg"
  }
}
