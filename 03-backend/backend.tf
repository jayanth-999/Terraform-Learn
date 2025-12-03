terraform {
  # In a real enterprise, this would be "s3" or "azurerm"
  # We are using "local" but pointing to a path OUTSIDE the project
  # to simulate a shared network drive or remote location.
  backend "local" {
    path = "./central-store/terraform.tfstate"
  }
}
