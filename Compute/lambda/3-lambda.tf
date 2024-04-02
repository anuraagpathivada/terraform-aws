# IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "flaskLambdaRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "lambda.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })
}

# Lambda function
resource "aws_lambda_function" "flask_lambda" {
  filename      = "flaskapp.zip"
  function_name = "practiceapp-lambda-function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.11"
  memory_size   = 256
  timeout       = 30
}

resource "aws_iam_policy" "basiclambdaexecution" {
  name        = "practice_lambda_basic_policy"
  description = "lambda basic execution policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Effect = "Allow",
            Action = [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            Resource = "*"
        },
     ]
    })
  tags = {
    Name     = "practice-lambda"
    "Terraform" = "true" 
  }
}

resource "aws_iam_role_policy_attachment" "lambda_role" {
  depends_on = [aws_iam_role.lambda_role]
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.basiclambdaexecution.arn
}

