# ==============================================================
# VPC CIDR
# ==============================================================

variable "vpc_cidr" {
  description = "VPC CIDR"
  type = string
}

# ==============================================================
# VPC DNS
# ==============================================================

variable "enable_dns_support" {
  description = "Enable DNS support"
  type = bool
}

variable "enable_dns_hostname" {
  description = "Enable DNS hostnames"
  type = bool
}

# ==============================================================
# Subnets with 3 Availability Zones
# Public subnets
# ==============================================================

variable "public_subnets" {
  description = "Public subnets"
  type = list(string)
}

# ==============================================================
# Private application subnets
# ==============================================================

variable "app_private_subnets" {
  description = "Application private subnets"
  type = list(string)
}

# ==============================================================
# Private database/cache subnets
# ==============================================================

variable "data_private_subnets" {
  description = "Data private subnets"
  type = list(string)
}

# ==============================================================
# FROM ANYWHERE
# ==============================================================

variable "anywhere" {
  description = "From anywhere"
  type = string
}

# ==============================================================
# APP TAGS
# ==============================================================

variable "tags" {
  type = map(string)
}