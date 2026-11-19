# ==============================================================
# REDIS SUBNETS
# ==============================================================

variable "redis_subnets" {
  type = list(string)
}

# ==============================================================
# REDIS SG
# ==============================================================

variable "redis_sg" {
  type = list(string)
}

# ==============================================================
# REDIS SUBNETS
# ==============================================================

variable "node_type" {
  type    = string
  default = "cache.t4g.micro"
}

# ==============================================================
# Apply Immediately
# ==============================================================

variable "apply_immediately" {
  type    = bool
  default = false
}

# ==============================================================
# Num Cache Nodes
# ==============================================================

variable "num_cache_nodes" {
  type    = number
  default = 2

  validation {
  condition     = var.num_cache_nodes >= 2
  error_message = "At least 2 cache nodes are required for automatic failover and Multi-AZ."
}
}

# ==============================================================
# APP TAGS
# ==============================================================

variable "tags" {
  type = map(string)
}