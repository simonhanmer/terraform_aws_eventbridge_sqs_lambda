data "archive_file" "reader_function_zip" {
  type        = "zip"
  source_file = "source/lambda/reader_lambda/lambda_function.py"
  output_path = "source/lambda/reader_lambda/lambda.zip"
}

resource "aws_lambda_function" "reader_function" {
  function_name                  = "${var.project_name}-reader-function"
  role                           = aws_iam_role.reader_lambda_execution_role.arn
  description                    = "Read SQS Events"
  filename                       = data.archive_file.reader_function_zip.output_path
  source_code_hash               = data.archive_file.reader_function_zip.output_base64sha256
  handler                        = "lambda_function.lambda_handler"
  runtime                        = "python3.9"
  reserved_concurrent_executions = 1
  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_event_source_mapping" {
  event_source_arn                   = aws_sqs_queue.sqs.arn
  function_name                      = aws_lambda_function.reader_function.arn
  maximum_batching_window_in_seconds = var.poll_window_in_seconds
  batch_size                         = 50
}

resource "aws_cloudwatch_log_group" "reader_lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.reader_function.function_name}"
  retention_in_days = 1
}
