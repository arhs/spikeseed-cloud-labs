
variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "handler" {
  description = "The name of the handler function in the Lambda function code"
  type        = string
}

variable "runtime" {
  description = "The runtime environment for the Lambda function"
  type        = string
}

variable "timeout" {
  description = "The maximum amount of time that the Lambda function can run"
  type        = number
}

variable "memory_size" {
  description = "The amount of memory allocated to the Lambda function"
  type        = number
}
