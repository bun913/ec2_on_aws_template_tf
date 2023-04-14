variable "env" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "key_name" {
  type        = string
  description = "Existing key pair name"
}
