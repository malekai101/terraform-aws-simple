// Infra

variable "project_name" {
    description = "The name of the project."
    type = string
}

variable "admin_ip" {
  description = "The IP address of the administrator"
  type = string
}

variable key {
    description = "SSH key to admin servers"
}

variable region {
    description = "The region for deployment"
    type = string
    validation {
        condition     = contains(["us-east1", "us-east2"], var.region)
        error_message = "The region must be a valid us-east region"
  }
}