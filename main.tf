provider "aws" {
  allowed_account_ids           = ["219831553792"]
  region                        = "us-east-2"
}

terraform {
  backend "s3" {
    bucket                      = "sheridanterraformtraining"
    key                         = "terraform.tfstate"
    encrypt                     = "false"
  }
}

module "base_module" {
  source                        = "./base-network"
  environment                   = "training"
  name                          = "base_training_module"
}

data "aws_ami" "ubuntu" {
  most_recent                   = true

  filter {
    name                        = "name"
    values                      = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name                        = "virtualization-type"
    values                      = ["hvm"]
  }

  owners                        = ["099720109477"]
}

resource "aws_security_group" "web_sg" {
  name                          = "allow-web"
  description                   = "allow traffic to 80"
  vpc_id                        = "${module.base_module.vpc_id}"

  ingress {
    from_port                   = 80
    to_port                     = 80
    protocol                    = "tcp"
    cidr_blocks                 = ["0.0.0.0/0"]
  }

  egress {
    from_port                   = 0
    to_port                     = 65535
    protocol                    = "tcp"
    cidr_blocks                 = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                           = "${data.aws_ami.ubuntu.id}"
  subnet_id                     = "${element(module.base_module.public_subnets, count.index)}"
  associate_public_ip_address   = "true"
  instance_type                 = "t2.micro"
  security_groups               = ["${aws_security_group.web_sg.id}"]
  user_data                     = "${file("./bootstrap.sh")}"
  count                         = 4
  tags {
    Name                        = "training-web${count.index}"
  }
}
