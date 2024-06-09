data "aws_availability_zone" "az" {
  name  = var.az
  state = "available"
}

output "availability_zone_to_region" {
  value = data.aws_availability_zone.az.id
}

output "alb_hostname" {
  value = "${aws_alb.main.dns_name}"
}

output "s3_bucket_id" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}