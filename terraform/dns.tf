# See https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-to-elb-load-balancer.html

# The DNS record for `mongoose-footprints.com` doesn't need to be managed by
# Terraform, but we can fetch info about it using the `data` directive
data "aws_route53_zone" "footprints" {
  name         = "mongoose-footprints.com."
  private_zone = false
}

# Route requests to `mongoose-footprints.com` to our ELB
resource "aws_route53_record" "footprints_elb_root" {
  zone_id = "${data.aws_route53_zone.footprints.zone_id}"
  name    = "${data.aws_route53_zone.footprints.name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.blue_green_elb.dns_name}"
    zone_id                = "${aws_lb.blue_green_elb.zone_id}"
    evaluate_target_health = true
  }
}

# Route requests to `www.mongoose-footprints.com` to our ELB
resource "aws_route53_record" "footprints_elb_www" {
  zone_id = "${data.aws_route53_zone.footprints.zone_id}"
  name    = "www.${data.aws_route53_zone.footprints.name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.blue_green_elb.dns_name}"
    zone_id                = "${aws_lb.blue_green_elb.zone_id}"
    evaluate_target_health = true
  }
}

# Route requests to the staging elb
resource "aws_route53_record" "staging_elb_www" {
  zone_id = "${data.aws_route53_zone.footprints.zone_id}"
  name    = "www.${data.aws_route53_zone.footprints.name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.staging_elb.dns_name}"
    zone_id                = "${aws_lb.staging_elb.zone_id}"
    evaluate_target_health = true
  }
}