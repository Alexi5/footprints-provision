# Configure our VPC
resource "aws_vpc" "blue_green_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "blue-green-vpc"
  }
}