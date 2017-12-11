module "base_module" {
  source = "./base-network"
}

provider "aws" {
  allowed_account_ids = "219831553792"
  region              = "us-east-2"
}

terraform {
  backend "s3" {
    bucket  = "sheridanterraformtraining"
    key     = "terraform.tfstate"
    encrypt = "false"
  }
}
