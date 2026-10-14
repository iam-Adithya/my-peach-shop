variable "region" {
  description = "Linode region code. ap-south is an India region; choose another region if needed."
  type        = string
  default     = "ap-south"
}

variable "instance_type" {
  description = "Linode plan. A Nanode is sufficient for a small static site."
  type        = string
  default     = "g6-dedicated-4"
}

variable "instance_label" {
  description = "Name shown in the Linode Cloud Manager."
  type        = string
  default     = "peach-shop-web"
}


variable "root_password" {
  description = "Root password for the Linode instance."
  type        = string
  sensitive   = true
}
variable "linode_token" {
  description = "Linode API token. Set this in your environment as LINODE_TOKEN."
  type        = string
  sensitive   = true
}
