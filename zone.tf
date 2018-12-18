# ACM certificate has to be in us-east-1 in order to work with CloudFront

provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "terraform"
  region                  = "eu-central-1"
}

# Hosted zone in Route53
resource "aws_route53_zone" "zone" {
  # imported existing zone
  name = "${var.primary_domain}."
}

# Primary domain DNS record
resource "aws_route53_record" "primary_domain" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name    = "${var.primary_domain}"
  type    = "A"

  alias {
    name                   = "s3-website.${aws_s3_bucket.primary_domain.region}.amazonaws.com."
    zone_id                = "${aws_s3_bucket.primary_domain.hosted_zone_id}"
    evaluate_target_health = false
  }
}

# Secondary domain DNS record

resource "aws_route53_record" "secondary_domain" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name    = "${var.secondary_domain}"
  type    = "A"

  alias {
    name                   = "s3-website.${aws_s3_bucket.primary_domain.region}.amazonaws.com."
    zone_id                = "${aws_s3_bucket.primary_domain.hosted_zone_id}"
    evaluate_target_health = false
  }
}
