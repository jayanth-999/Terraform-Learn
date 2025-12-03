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

# We want to manage this resource, but it already exists in Azure!
resource "azurerm_resource_group" "legacy" {
  name     = "rg-manual-demo"
  location = "East US"
}
