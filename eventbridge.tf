resource "aws_cloudwatch_event_rule" "test_bucket_event_rule" {
  name        = "${var.project_name}-test-bucket-event-rule"
  description = "Rule to trigger eventbridge on PutObject to test bucket"

  event_pattern = jsonencode(
    {
      "source" : ["aws.s3"],
      "detail-type" : ["AWS API Call via CloudTrail"],
      "detail" : {
        "eventSource" : ["s3.amazonaws.com"],
        "eventName" : ["PutObject"],
        "requestParameters" : {
          "bucketName" : [aws_s3_bucket.test_bucket.id]
        }
      }
    }
  )
}

resource "aws_cloudwatch_event_target" "sqs_writer" {
  rule = aws_cloudwatch_event_rule.test_bucket_event_rule.name
  arn  = aws_sqs_queue.sqs.arn
  dead_letter_config {
    arn = aws_sqs_queue.sqs_dead_letter_queue.arn
  }
}
