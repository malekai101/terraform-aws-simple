// Infra

variable "project_name" {
    description = "The name of the project."
    type = string
}

variable "admin_ip" {
  description = "The IP address of the administrator"
  type = string
  validation {
    condition     = can(cidrhost(var.admin_ip, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable key {
    description = "SSH key to admin servers"
}
