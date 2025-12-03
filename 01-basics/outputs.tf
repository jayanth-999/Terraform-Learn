output "file_id" {
  description = "The ID of the created file"
  value       = local_file.hello.id
}

output "file_path" {
  description = "The full path of the created file"
  value       = local_file.hello.filename
}
