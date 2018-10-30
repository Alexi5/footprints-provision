# Create an EC2 instance for our initial "blue" application
resource "aws_instance" "blue_ec2" {
  connection {
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)})"
  }

  ami                    = "ami-059eeca93cf09eebd" # Ubuntu Server 16.04 LTS (HVM), SSD Volume Type
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.blue_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.blue_green_instance_security_group.id}"]
  key_name               = "${aws_key_pair.auth.id}"

  # Install Python immediately to support running Ansible
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install python",
    ]
  }

  tags {
    Name = "blue_ec2"
  }
}

# Create an EC2 instance for our initial "green" application
resource "aws_instance" "green_ec2" {
  connection {
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }

  ami                    = "ami-059eeca93cf09eebd" # Ubuntu Server 16.04 LTS (HVM), SSD Volume Type
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.green_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.blue_green_instance_security_group.id}"]
  key_name               = "${aws_key_pair.auth.id}"

  # Install Python immediately to support running Ansible
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install python",
    ]
  }

  tags {
    Name = "green_ec2"
  }
}

# Provides security group configuration for EC2 instances (eg. SSH and HTTP)
resource "aws_security_group" "blue_green_instance_security_group" {
  name        = "blue_green_instance_security_group"
  vpc_id      = "${aws_vpc.production_and_staging_vpc.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP access from the VPC
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.production_and_staging_vpc.cidr_block}"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the subnet for the "blue" EC2
resource "aws_subnet" "blue_subnet" {
  availability_zone       = "us-east-1b"
  vpc_id                  = "${aws_vpc.production_and_staging_vpc.id}"
  cidr_block              = "10.0.1.0/24"

  # Make sure EC2 instances added to this subnet get public IP addresses
  map_public_ip_on_launch = true

  tags {
    Name = "blue_subnet"
  }
}

# Create the subnet for the "green" EC2
resource "aws_subnet" "green_subnet" {
  availability_zone       = "us-east-1a"
  vpc_id                  = "${aws_vpc.production_and_staging_vpc.id}"
  cidr_block              = "10.0.2.0/24"

  # Make sure EC2 instances added to this subnet get public IP addresses
  map_public_ip_on_launch = true

  tags {
    Name = "green_subnet"
  }
}