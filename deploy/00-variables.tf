variable "github_token" {}

variable "github_username" {}

variable "github_project_name" {}

variable "app_name" {}

variable "environment" {}

variable "default_region" {}

variable "common_tags" {
  description = "Common tags to be applied to all components."
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}

