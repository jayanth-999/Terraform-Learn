resource "local_file" "cloud_state" {
  filename = "${path.module}/cloud_state.txt"
  content  = "This resource's state is safely stored in Azure Blob Storage!"
}
