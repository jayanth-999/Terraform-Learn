resource "local_file" "environment_config" {
  filename = "${path.module}/${terraform.workspace}-config.txt"
  content  = <<EOT
Current Environment: ${terraform.workspace}
Database URL: db-${terraform.workspace}.example.com
Log Level: ${terraform.workspace == "prod" ? "ERROR" : "DEBUG"}
EOT
}
