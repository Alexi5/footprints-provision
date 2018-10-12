resource "aws_db_instance" "footprints" {
  identifier           = "footprints"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "footprints_production"
  availability_zone    = "us-east-1a"

  # Hardcode the credentials for now; we'll need to make these dynamic once this
  # provisioning approach is verified
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  parameter_group_name = "default.mysql5.7"

  # Attach the RDS instance to the Footprints db subnet group
  db_subnet_group_name = "${aws_db_subnet_group.footprints_db_subnet_group.name}"

  # Prevent deletion of the database on Terraform teardown
  deletion_protection       = true
  final_snapshot_identifier = "footprints-db-final-snapshot"
  copy_tags_to_snapshot     = true

  vpc_security_group_ids = ["${aws_security_group.footprints_db_security_group.id}"]

  tags {
    Name = "footprints_db"
  }

  depends_on = [
    "aws_db_subnet_group.footprints_db_subnet_group",
    "aws_security_group.footprints_db_security_group"
  ]
}

resource "aws_security_group" "footprints_db_security_group" {
  name   = "footprints_db_security_group"
  vpc_id = "${aws_vpc.blue_green_vpc.id}"

  # MySQL access from the EC2 subnets
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [
      "${aws_subnet.green_subnet.cidr_block}",
      "${aws_subnet.blue_subnet.cidr_block}"
    ]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "footprints_db_subnet_group" {
  name       = "footprints-db-subnet-group"
  subnet_ids = ["${aws_subnet.blue_subnet.id}", "${aws_subnet.green_subnet.id}"]

  tags {
    Name = "footprints_db_subnet_group"
  }
}