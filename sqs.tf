resource "aws_sqs_queue" "sqs" {
  name                       = "${var.project_name}-queue"
  visibility_timeout_seconds = 10
  message_retention_seconds  = 86400        # 1 day
  policy                     = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "EventBridgetoSQS"
        Principal = { "Service" = "events.amazonaws.com" }
        Action    = [ "sqs:SendMessage" ]
        Effect    = "Allow"
        Resource  = "arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:${var.project_name}-queue"
        Condition = {
            ArnEquals = {
                "aws:SourceArn" = aws_cloudwatch_event_rule.test_bucket_event_rule.arn
            }
        }
      }
    ]    
  })
}

resource "aws_sqs_queue" "sqs_dead_letter_queue" {
  name = "${var.project_name}-dlq"
  policy                     = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "EventBridgetoSQS"
        Principal = { "Service" = "events.amazonaws.com" }
        Action    = [ "sqs:SendMessage" ]
        Effect    = "Allow"
        Resource  = "arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:${var.project_name}-dlq"
        Condition = {
            ArnEquals = {
                "aws:SourceArn" = aws_cloudwatch_event_rule.test_bucket_event_rule.arn
            }
        }
      }
    ]    
  })
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
    sourceQueueArns   = [aws_sqs_queue.sqs.arn]
  })
}
