variable "filename" {
  description = "The name of the file to create"
  type        = string
  default     = "hello.txt"
}

variable "content" {
  description = "The content of the file"
  type        = string
  default     = "Hello from Variables!"
}
