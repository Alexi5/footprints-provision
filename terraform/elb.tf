# Create our Elastic Load Balancer
resource "aws_lb" "blue_green_elb" {
  name                = "blue-green-elb"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = ["${aws_security_group.blue_green_elb_security_group.id}"]
  subnets             = [
    "${aws_subnet.green_subnet.id}",
    "${aws_subnet.blue_subnet.id}"
  ]

  idle_timeout        = 400

  tags {
    Name = "blue-green-elb"
  }
}

# Create ELB for staging instance
resource "aws_lb" "staging_elb" {
  name				 = "staging-elb"
  internal			 = false
  load_balancer_type = "application"
  security_groups	 = ["${aws_security_group.blue_green_elb_security_group.id}"]
  subnets			 = ["${aws_subnet.blue_subnet.id}",
  						"${aws_subnet.green_subnet.id}"
  ]
  
  idle_timeout		 = 400
  
  tags {
    Name = "staging-elb"
  }
}

# Security for the staging 

# Provides security group configuration for the ELB itself (eg. internet access)
resource "aws_security_group" "blue_green_elb_security_group" {
  name        = "blue_green_elb_security_group"
  vpc_id      = "${aws_vpc.blue_green_vpc.id}"

  # ICMP access from anywhere
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an ELB target group so the load balancer can send requests to one (or
# many) instances associated with the group
resource "aws_lb_target_group" "blue_elb_target_group" {
  name        = "blue-ec2-elb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "${aws_vpc.blue_green_vpc.id}"

  health_check {
    port = 80
    matcher = "200,301,302"
  }

  tags {
    Name = "blue-elb-target-group"
  }
}

# Old: Attach the EC2 instance for the "blue" EC2 instance to the blue target group
# Attach blue target group to the staging instance
resource "aws_lb_target_group_attachment" "blue_elb_target_group_attachment" {
  target_group_arn = "${aws_lb_target_group.blue_elb_target_group.arn}"
  target_id        = "${aws_lb.staging_elb.id}"
  port             = 80
}

# Create an ELB target group so the load balancer can send requests to one (or
# many) instances associated with the group
resource "aws_lb_target_group" "green_elb_target_group" {
  name        = "green-ec2-elb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "${aws_vpc.blue_green_vpc.id}"

  health_check {
    port = 80
    matcher = "200,301,302"
  }

  tags {
    Name = "green-elb-target-group"
  }
}

# Attach the EC2 instance for the "green" EC2 instance to the green target group
resource "aws_lb_target_group_attachment" "green_elb_target_group_attachment" {
  target_group_arn = "${aws_lb_target_group.green_elb_target_group.arn}"
  target_id        = "${aws_instance.green_ec2.id}"
  port             = 80
}

# Initially configure our load balancer to forward HTTP requests on port 80 to
# the "green" target group (and thus the "green" EC2)
resource "aws_lb_listener" "blue_green_elb_listener" {
  "default_action" {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.green_elb_target_group.arn}"
  }

  load_balancer_arn = "${aws_lb.blue_green_elb.arn}"
  port              = 80
  protocol          = "HTTP"
}