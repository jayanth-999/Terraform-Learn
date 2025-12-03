terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "debug" {
  name     = "rg-debug-demo"
  location = "East US"
}

# ERROR 1: Invalid Name (Azure storage accounts must be lowercase and alphanumeric)
resource "azurerm_storage_account" "broken" {
  name                     = "mystorageaccount123" # <--- This is invalid!
  resource_group_name      = azurerm_resource_group.debug.name
  location                 = azurerm_resource_group.debug.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# ERROR 2: Reference to non-existent attribute
output "storage_id" {
  value = azurerm_storage_account.broken.id # <--- Storage accounts don't have an ip_address attribute!
}
