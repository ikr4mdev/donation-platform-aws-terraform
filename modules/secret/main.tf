# ============================================================
# SECRET MANAGER
# ============================================================

resource "aws_secretsmanager_secret" "secret" {
  name = "${terraform.workspace}-secret-manager"
  description = "Application secret for ${terraform.workspace}" # for dev or prod

  recovery_window_in_days = 7

  tags = merge(
    {
        Name = "${terraform.workspace}-secret-manager"
    },

    var.tags
  )
}

# ============================================================
# SECRET VALUES
# ============================================================

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret.id

  secret_string = jsonencode({
    DB_NAME = var.db_name
    DB_USERNAME = var.db_username
    DB_PASSWORD = var.db_password
    ACCESS_TOKEN_SECRET = var.access_token_secret
    REFRESH_TOKEN_SECRET = var.refresh_token_secret
  })
}