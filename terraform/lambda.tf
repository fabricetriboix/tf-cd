resource "aws_iam_policy" "this" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "this" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

data "archive_file" "this" {
  type = "zip"
  output_path = "hello.zip"
  source_file = "../src/hello.py"
}

resource "aws_lambda_function" "this" {
  function_name = "Hello"
  runtime = "python3.9"
  role = aws_iam_role.this.arn
  filename = data.archive_file.this.output_path
  source_code_hash = filebase64sha256(data.archive_file.this.output_path)
  handler = "hello.entry_point"
}
