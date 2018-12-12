resource "aws_instance" "logstash_and_elastic_ec2" {
  connection {
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)})"
  }

  ami                    = "ami-059eeca93cf09eebd" # Ubuntu Server 16.04 LTS (HVM), SSD Volume Type
  instance_type          = "t2.medium"
  vpc_security_group_ids = ["${aws_security_group.logstash_and_elastic_sg.id}"]
  key_name               = "${aws_key_pair.auth.id}"

  # Install Python immediately to support running Ansible
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install python",
    ]
  }

  tags {
    Name = "logstash_and_elastic_ec2"
  }
}

resource "aws_security_group" "logstash_and_elastic_sg" {
	egress {
		from_port = 0
		to_port	= 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
	
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	
	ingress {
		from_port = 5044
		to_port = 5044
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	
	ingress {
		from_port = 9600
		to_port = 9600
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

output "logstash_and_elastic_ec2_host" {
	value = "${aws_instance.logstash_and_elastic_ec2.public_dns}"
}

# Output the Elk public IP address
output "logstash_and_elastic_ec2_ip" {
	value = "${aws_instance.logstash_and_elastic_ec2.public_ip}"
}