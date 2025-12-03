module "my_first_module" {
  source = "./modules/file_writer"

  filepath     = "${path.module}/module_output.txt"
  file_content = "I was created by a reusable module!"
}

module "my_second_module" {
  source = "./modules/file_writer"

  filepath     = "${path.module}/another_file.txt"
  file_content = "I am a second instance of the same module."
}
