variable "region" {
  description = "AWS region"
  default     = "eu-west-3"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

provider "aws" {
  region = var.region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "backend_env" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  tags = {
    Name = "Rcvo-Backend-env"
  }
}

resource "aws_instance" "backend_lb" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  tags = {
    Name = "Rcvo-Backend-lb"
  }
}
