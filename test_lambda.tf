data "archive_file" "test_writer_function_zip" {
  type        = "zip"
  source_file = "source/lambda/test_writer_lambda/lambda_function.py"
  output_path = "source/lambda/test_writer_lambda/lambda.zip"
}

resource "aws_lambda_function" "test_writer_function" {
  function_name    = "${var.project_name}-test-function"
  role             = aws_iam_role.test_writer_lambda_execution_role.arn
  description      = "Write random data to test s3 bucket when invoked to test eventbridge"
  filename         = data.archive_file.test_writer_function_zip.output_path
  source_code_hash = data.archive_file.test_writer_function_zip.output_base64sha256
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  timeout          = 30
  environment {
    variables = {
      LOG_LEVEL = "INFO"
      BUCKET_NAME = aws_s3_bucket.test_bucket.id
      # FILE_COUNT = 10
    }
  }
}

resource "aws_cloudwatch_log_group" "test_lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.test_writer_function.function_name}"
  retention_in_days = 1
}
