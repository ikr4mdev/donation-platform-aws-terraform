# ==============================================================
# DB
# ==============================================================

variable "db_name"          { type = string }
variable "db_username"      { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "db_port" {
  type    = number
  default = 5432
}

# ==============================================================
# Postgres Security Group
# ==============================================================

variable "postgres_sg" {
  type = list(string)
}

# ==============================================================
# Postgres private Subnets
# ==============================================================

variable "postgres_subnets" {
  type = list(string)
}

# ==============================================================
# Deletion Protection
# ==============================================================

variable "deletion_protection" {
  type = bool
}

# ==============================================================
# Apply Immediately
# ==============================================================

variable "apply_immediately" {
  type = bool
}

# ==============================================================
# Multi AZs
# ==============================================================

variable "multi_az" {
  type    = bool
  default = false
}

# ==============================================================
# skip_final_snapshot
# ==============================================================

variable "skip_final_snapshot" {
  type    = bool
  default = false
}

# ==============================================================
# APP TAGS
# ==============================================================

variable "tags" {
  type = map(string)
}