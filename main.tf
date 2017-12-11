module "base_module" {
  source = "./base-network"
}

provider "aws" {
  allowed_account_ids = "${var.account_ids}"
  region              = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket  = "sheridanterraformtraining"
    key     = "terraform.tfstate"
    encrypt = "false"
  }
}
