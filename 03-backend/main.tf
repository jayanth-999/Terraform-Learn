resource "local_file" "backend_demo" {
  filename = "${path.module}/backend_demo.txt"
  content  = "This resource's state is stored in a central location, not here!"
}
