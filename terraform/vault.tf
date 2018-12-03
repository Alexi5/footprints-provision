resource "aws_security_group" "vault_security_group" {
  ingress {
    from_port = 8200
    to_port = 8200
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  # SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_instance" "vault" {
  connection {
    user = "ubuntu"
    private_key = "${file(var.private_key_path)})"
  }

  ami = "ami-059eeca93cf09eebd"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = [
    "${aws_security_group.vault_security_group.id}"
  ]

  # Install Python immediately to support running Ansible
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install python",
    ]
  }

  tags {
    Name = "vault"
  }
}

output "vault_ec2_host" {
  value = "${aws_instance.vault.public_dns}"
}

output "vault_ec2_ip" {
  value = "${aws_instance.vault.public_ip}"
}