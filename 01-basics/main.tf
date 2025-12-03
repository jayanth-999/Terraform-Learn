resource "local_file" "hello" {
  filename = "${path.module}/${var.filename}"
  content  = var.content
}
