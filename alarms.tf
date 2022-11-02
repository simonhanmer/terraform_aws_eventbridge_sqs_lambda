resource "aws_cloudwatch_metric_alarm" "name" {
    alarm_name = "${var.project_name}-eventbridge-failed-invocation"
    alarm_description = "Monitor failed eventbridge rule invocations"

    namespace = "AWS/Events"
    metric_name = "FailedInvocations"
    dimensions = {
        RuleName = aws_cloudwatch_event_rule.test_bucket_event_rule.name
    }

    comparison_operator = "GreaterThanThreshold"
    period = 60
    evaluation_periods = 5
    statistic = "Average"
    threshold = "1"
    treat_missing_data = "ignore"
}