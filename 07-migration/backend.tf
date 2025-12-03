terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatey4bd4" # <--- We put the value you just created here!
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate" # The name of the file in the cloud
  }
}
