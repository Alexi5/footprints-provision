# The internet gateway allows our VPC to connect to the public internet
resource "aws_internet_gateway" "blue_green_internet_gateway" {
  vpc_id = "${aws_vpc.blue_green_vpc.id}"

  tags {
    Name = "blue-green-internet-gateway"
  }
}

# Define the routing configuration so that the internet gateway can talk to the
# whole public internet (CIDR 0.0.0.0/0)
resource "aws_route" "blue_green_internet_access_route" {
  route_table_id         = "${aws_vpc.blue_green_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.blue_green_internet_gateway.id}"
}