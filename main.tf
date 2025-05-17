terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # backend "s3" {
  # bucket         = "hive-terraform-state"
  # key            = "hiive-eks-dev/terraform.tfstate"
  # region         = "us-east-1"
  # dynamodb_table = "terraform-state-lock"
  # encrypt        = true
  #}

}


provider "aws" {
  region  = "ca-central-1"
  profile = "squadery-eks-user-prod" # profile with appropriate access
  default_tags {
    tags = {
      "creator" = "Suman Gautam"
      "env"     = "dev"
      "cluster" = "hiive-autoscalable-dev"
    }
  }
}

module "eks" {
  source       = "./module"
  clusterName  = "hiive-autoscalable-dev"
  instanceType = ["t3.medium"]
  max_instance = "5"
  templateName = "hive-eks-template-dev"
  env          = "dev"
}