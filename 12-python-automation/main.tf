variable "environment" {
  type = string
}

resource "local_file" "app_config" {
  filename = "${path.module}/config-${var.environment}.json"
  content  = <<EOF
{
  "environment": "${var.environment}",
  "db_host": "db-${var.environment}.example.com",
  "debug": ${var.environment == "dev" ? "true" : "false"}
}
EOF
}

output "config_file" {
  value = local_file.app_config.filename
}
