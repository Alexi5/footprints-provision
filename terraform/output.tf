# Output the "blue" EC2's public IP address
output "blue_ec2_ip" {
  value = "${aws_instance.blue_ec2.public_ip}"
}

# Output the "green" EC2's public IP address
output "green_ec2_ip" {
  value = "${aws_instance.green_ec2.public_ip}"
}

# Output the domain name of the load balancer
output "blue_green_elb_domain" {
  value = "${aws_lb.blue_green_elb.dns_name}"
}

# Output the ARN of the load balancer
output "blue_green_elb_arn" {
  value = "${aws_lb.blue_green_elb.arn}"
}

# Output the name of the load balancer
output "blue_green_elb_name" {
  value = "${aws_lb.blue_green_elb.name}"
}

# Output the ARN of the "blue" ELB target group
output "blue_target_group_arn" {
  value = "${aws_lb_target_group.blue_elb_target_group.arn}"
}

# Output the ARN of the "green" ELB target group
output "green_target_group_arn" {
  value = "${aws_lb_target_group.green_elb_target_group.arn}"
}

# Output the Footprints DB's hostname
output "footprints_db_host" {
  value = "${aws_db_instance.footprints.address}"
}

# Output the Footprints DB's database name
output "footprints_db_name" {
  value = "${aws_db_instance.footprints.name}"
}

# Output the Footprints DB's database username
output "footprints_db_user" {
  value = "${aws_db_instance.footprints.username}"
}

# Output the Footprints DB's database password
output "footprints_db_pass" {
  value = "${aws_db_instance.footprints.password}"
}
