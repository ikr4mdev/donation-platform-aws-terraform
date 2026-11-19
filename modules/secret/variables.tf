# ==============================================================
# DB
# ==============================================================
variable "access_token_secret" {
  type = string
  sensitive = true
}
variable "refresh_token_secret" {
  type = string
  sensitive = true
}

variable "db_name" {
  type = string
  sensitive = true
}
variable "db_username" {
  type = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

# ==============================================================
# APP TAGS
# ==============================================================

variable "tags" {
  type = map(string)
}