variable "region" {
  type        = string
  description = "which region to deploy infra to"
  default     = "eu-west-1"
}

variable "project_name" {
  type        = string
  description = "Name of project, used to build resource names"
  default     = "sqs-demo-simon"
}

variable "poll_window_in_seconds" {
    type        = number
    description = "max. number of seconds to poll sqs for before triggering lambda"
    default     = 300
}