# S3 bucket for hosting static website
resource "aws_s3_bucket" "primary_domain" {
  bucket = "${var.primary_domain}"
  acl    = "public-read"
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
	"Sid":"PublicReadGetObject",
        "Effect":"Allow",
	  "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.primary_domain}/*"
      ]
    }
  ]
}
POLICY


website {
  index_document = "index.html"
  error_document = "error.html"
  routing_rules = <<EOF
    [{
      "Condition": {
      "KeyPrefixEquals": "docs/"
      },
      "Redirect": {
      "ReplaceKeyPrefixWith": "documents/"
      }
      }]
EOF
  }
}

resource "aws_s3_bucket" "secondary_domain" {
  bucket = "${var.secondary_domain}"
  acl = "public-read"
  website {
    redirect_all_requests_to = "${var.primary_domain}"
    }
  }


# Hello, world HTML file
resource "aws_s3_bucket_object" "index_html" {
  bucket       = "${aws_s3_bucket.primary_domain.id}"
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}
