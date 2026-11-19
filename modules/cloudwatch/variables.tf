variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "log_retention_days" {
  description = "Retention period for CloudWatch logs"
  type        = number
  default     = 14

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.log_retention_days)
    error_message = "Must be a valid CloudWatch retention value."
  }
}