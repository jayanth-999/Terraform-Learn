resource "local_file" "this" {
  filename = var.filepath
  content  = var.file_content
}
