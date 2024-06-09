variable "region_number" {
  # Arbitrary mapping of region name to number to use in
  # a VPC's CIDR prefix.
  default = {
    eu-west-1 = 1
    eu-west-2 = 2
  }
}

variable "az_number" {
  # Assign a number to each AZ letter used in our configuration
  default = {
    a = 1
    b = 2
  }
}

variable "az" {
  default = "eu-west-1a"
}

variable "app_name" {
  type        = string
  default = "Levi9-ati"
}

variable "app_environment" {
  type        = string
  default = "user environment"
}

variable "aws_region" {
    description = "The AWS region things are created in"
    default = "eu-west-1"
}

variable "app_port" {
    description = "App port"
    default = 80
}

variable "app_secure_port" {
    description = "App secure port"
    default = 443
}

#########

variable "ec2_task_execution_role_name" {
    description = "ECS task execution role name"
    default = "myEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
    description = "ECS auto scale role name"
    default = "myEcsAutoScaleRole"
}

variable "az_count" {
    description = "Number of AZs to cover in a given region"
    default = "2"
}

variable "app_image" {
    description = "Docker image to run in the ECS cluster"
    default = "992382501500.dkr.ecr.eu-west-1.amazonaws.com/praksa-repo:latest"
}

variable "app_count" {
    description = "Number of docker containers to run"
    default = 3
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
    default = "1024"
}

variable "fargate_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    default = "2048"
}

variable "dynamo_table_name" {
  default = "dynamotb"
}

variable "api_gateway_name" {
  default = "praksa-api"
}

variable "acm_cert_arn_north_virginia" {
  default = "arn:aws:acm:us-east-1:992382501500:certificate/e83b2175-7ffd-4493-b642-9f0139086a2e"
}

variable "s3_static_website_bucket" {
  default = "devopspraksans2024.com"
}