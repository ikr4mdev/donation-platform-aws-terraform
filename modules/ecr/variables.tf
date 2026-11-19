# ==============================================================
# Image Tag Mutability
# ==============================================================

variable "image_tag_mutability" {
  description = "MUTABLE or IMMUTABLE"
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Must be MUTABLE or IMMUTABLE."
  }
}

# ==============================================================
# Force Delete
# ==============================================================

variable "force_delete" {
  description = "Delete repo even if it contains images"
  type        = bool
  default     = false
}

# ==============================================================
# Encryption Type
# ==============================================================

variable "encryption_type" {
  description = "AES256 or KMS"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "Must be AES256 or KMS."
  }
}

# ==============================================================
# Scan On Push
# ==============================================================

variable "scan_on_push" {
  type        = bool
  default     = true
}

# ==============================================================
# APP TAGS
# ==============================================================

variable "tags" {
  type = map(string)
}