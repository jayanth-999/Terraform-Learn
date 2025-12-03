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

resource "azurerm_resource_group" "net" {
  name     = "rg-networking-demo"
  location = "East US"
}

module "my_vnet" {
  source = "./modules/vnet"

  resource_group_name = azurerm_resource_group.net.name
  location            = azurerm_resource_group.net.location
  vnet_name           = "vnet-prod-01"
  address_space       = ["10.0.0.0/16"]

  # This is the power of for_each!
  # We define subnets as data, and the module loops through them.
  subnets = {
    "subnet-web" = "10.0.1.0/24"
    "subnet-db"  = "10.0.2.0/24"
    "subnet-app" = "10.0.3.0/24"
  }
}

output "created_subnets" {
  value = module.my_vnet.subnet_ids
}
