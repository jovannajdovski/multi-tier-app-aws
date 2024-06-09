locals {
  s3_origin_id   = "${aws_s3_bucket.website_bucket.bucket_regional_domain_name}-origin"
  s3_domain_name = "${aws_s3_bucket_website_configuration.website.website_endpoint}"
}

resource "aws_cloudfront_distribution" "cf" {

  aliases = ["front.devopspraksans2024.com"]

  enabled = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    origin_id                = local.s3_origin_id
    domain_name              = local.s3_domain_name
    custom_origin_config {
      http_port              = var.app_port
      https_port             = var.app_secure_port
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1"]
    }
  }

  default_cache_behavior {

    target_origin_id = local.s3_origin_id
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_cert_arn_north_virginia
    ssl_support_method = "sni-only"
  }

  price_class = "PriceClass_100"

  depends_on = [ aws_s3_bucket.website_bucket ]
}