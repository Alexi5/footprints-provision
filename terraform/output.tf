# Output the "blue" EC2's public IP address
output "blue_ec2_ip" {
  value = "${aws_instance.blue_ec2.public_ip}"
}

# Output the "green" EC2's public IP address
output "green_ec2_ip" {
  value = "${aws_instance.green_ec2.public_ip}"
}

# Output the Elk public IP address
output "logstash_and_elastic_ec2_ip" {
  value = "${aws_instance.logstash_and_elastic_ec2.public_ip}"
}

# Output the domain name of the load balancer
output "production_elb_domain" {
  value = "${aws_lb.production_elb.dns_name}"
}

# Output the ARN of the load balancer
output "production_elb_arn" {
  value = "${aws_lb.production_elb.arn}"
}

# Output the name of the load balancer
output "production_elb_name" {
  value = "${aws_lb.production_elb.name}"
}

# Output the ARN of the load balancer
output "staging_elb_arn" {
  value = "${aws_lb.staging_elb.arn}"
}

# Output the name of the load balancer
output "staging_elb_name" {
  value = "${aws_lb.staging_elb.name}"
}

# Output the ARN of the "blue" ELB target group
output "blue_target_group_arn" {
  value = "${aws_lb_target_group.staging_elb_target_group.arn}"
}

# Output the ARN of the "green" ELB target group
output "green_target_group_arn" {
  value = "${aws_lb_target_group.production_elb_target_group.arn}"
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

output "staging_elb_target_group_attachment" {
  value = "${aws_lb_target_group_attachment.staging_elb_target_group_attachment.target_id}"
}

output "production_elb_target_group_attachment" {
  value = "${aws_lb_target_group_attachment.production_elb_target_group_attachment.target_id}"
}

output "omniauth_client_id" {
  value = "${data.vault_generic_secret.omniauth.data["client_id"]}"
}

output "omniauth_client_secret" {
  value = "${data.vault_generic_secret.omniauth.data["client_secret"]}"
}
