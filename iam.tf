resource "aws_iam_policy" "lambda_logging_policy" {
  name        = "policy_${var.project_name}"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow"
        Sid      = "LambdaLogging"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role" "reader_lambda_execution_role" {
  name = "${var.project_name}-writer-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "policy_${var.project_name}"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "WriteSQS"
          Action = [
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes",
            "sqs:ReceiveMessage"
          ]
          Effect = "Allow"
          Resource = [
            aws_sqs_queue.sqs.arn
          ]
        }
      ]
    })
  }
}

resource "aws_iam_role_policy_attachment" "reader_role_policy_attachment" {
  role       = aws_iam_role.reader_lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}