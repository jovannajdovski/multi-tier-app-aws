#POLICY function will be able to access and perform inside your AWS account

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambdaRole" {
  name               = "lambdaRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambdaRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#IAM POLICY FOR DYNAMODB -> Lambda
resource "aws_iam_policy" "dynamoDBLambdaPolicy" {
  name = "DynamoLambdaPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = [
          aws_dynamodb_table.dynamodb-table.arn
        ]
      }
    ]
  })
}

#IAM policy to our role
resource "aws_iam_role_policy_attachment" "aws-policy-attachment" {
  role       = aws_iam_role.lambdaRole.name
  policy_arn = aws_iam_policy.dynamoDBLambdaPolicy.arn
}


# Define ECS task execution IAM role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach policies to ECS task execution IAM role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM policy for 
resource "aws_iam_policy" "getEC2AvailabilityZonePolicy" {
  name = "EC2AZPolicy"
  policy = jsonencode ({
    Version = "2012-10-17",
    Statement = [
        {
            Effect = "Allow",
            Action = "ec2:DescribeAvailabilityZones",
            Resource = "*"
        }
    ]
  })
}

resource "aws_iam_policy" "lambda_apigateway_policy" {
  name        = "Lambda_APIGateway_Policy"
  description = "Policy for minimal permissions required for Lambda and API Gateway REST"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:InvokeFunction"
        Resource = "arn:aws:lambda:*:*:function:*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "apigateway:GET",
          "apigateway:POST",
          "apigateway:PUT",
          "apigateway:DELETE",
        ]
        Resource = "arn:aws:apigateway:*::/restapis/*"
      },
    ]
  })
}
