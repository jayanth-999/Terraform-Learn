terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "compute" {
  name     = "rg-compute-demo"
  location = "East US"
}

resource "azurerm_virtual_network" "compute" {
  name                = "vnet-compute"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.compute.location
  resource_group_name = azurerm_resource_group.compute.name
}

resource "azurerm_subnet" "compute" {
  name                 = "subnet-compute"
  resource_group_name  = azurerm_resource_group.compute.name
  virtual_network_name = azurerm_virtual_network.compute.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "compute" {
  name                = "pip-compute"
  location            = azurerm_resource_group.compute.location
  resource_group_name = azurerm_resource_group.compute.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "compute" {
  name                = "nic-compute"
  location            = azurerm_resource_group.compute.location
  resource_group_name = azurerm_resource_group.compute.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.compute.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.compute.id
  }
}

# The Magic: Cloud-Init Script
# This runs ONCE when the VM boots.
locals {
  custom_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
echo "<h1>Hello from Terraform Agent!</h1>" | sudo tee /var/www/html/index.html
EOF
}

# Generate an SSH key dynamically for this demo
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "compute" {
  name                = "vm-agent-01"
  resource_group_name = azurerm_resource_group.compute.name
  location            = azurerm_resource_group.compute.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.compute.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(local.custom_data)
}

output "private_key_pem" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

output "public_ip" {
  value = azurerm_public_ip.compute.ip_address
}
