resource "local_file" "inventory" {
  filename = "${path.module}/inventory.ini"
  content  = <<EOF
[webservers]
192.168.1.10 ansible_user=adminuser
EOF
}

# This resource does nothing but trigger a command
resource "null_resource" "run_ansible" {
  # Triggers the provisioner whenever the inventory file changes
  triggers = {
    inventory_id = local_file.inventory.id
  }

  provisioner "local-exec" {
    # In a real scenario, this would be:
    # command = "ansible-playbook -i inventory.ini playbook.yml"
    
    # For our simulation (Windows compatible):
    command = "echo 'Simulating Ansible Run...'; type playbook.yml"
    interpreter = ["PowerShell", "-Command"]
  }
}
