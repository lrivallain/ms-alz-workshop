variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "workshop"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}
