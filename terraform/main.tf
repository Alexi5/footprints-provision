# This terraform file is an attempt to provision AWS resources to create an ELB
# with listener groups pointing to 2 separate EC2 instances. The goal is to
# create a script that can provision infrastructure that supports a blue-green
# deployment approach in an automated fashion.
#
# These blog posts were very helpful:
# http://blog.kaliloudiaby.com/index.php/terraform-to-provision-vpc-on-aws-amazon-web-services/
# https://www.bogotobogo.com/DevOps/DevOps-Terraform.php

terraform {
  backend "s3" {
    encrypt = true
    bucket = "mongeeses-terraform-state-storage-s3"
    dynamodb_table = "dynamodb_terraform_state_lock"
    region = "us-east-1"
    key = "terraform-state/repository/footprints-provision"
  }
}

provider "aws" {
  region = "us-east-1"
}

# Set up the public SSH key we should use for interacting with the EC2 instances
resource "aws_key_pair" "auth" {
  key_name   = "production_and_staging_key_pair"
  public_key = "${file(var.public_key_path)}"
}