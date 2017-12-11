provider "aws" {
  allowed_account_ids = ["219831553792"]
  region              = "us-east-2"
}

terraform {
  backend "s3" {
    bucket  = "sheridanterraformtraining"
    key     = "terraform.tfstate"
    encrypt = "false"
  }
}

module "base_module" {
  source = "./base-network"
  environment = "training"
  name = "base_training_module"
}

resource "aws_instance" "web" {
  ami = "ami-aa1b34cf"
  subnet_id = "${module.base_module.public_subnets[0]}"
  instance_type = "t2.micro"
}
