# Look up the data for our SSL certificate for
# *.mongoose-footprints.com. Terraform cannot manage
# the cert directly, but can look it up for reference.
data "aws_acm_certificate" "footprints_production" {
  domain   = "*.mongoose-footprints.com"
  statuses = ["ISSUED"]
}