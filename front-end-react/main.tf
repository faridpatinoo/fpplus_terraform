
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.16.0"
    }
  }

  #tf state file will be stored in Azure Storage Account
  backend "azurerm" {
    resource_group_name  = "fpplus-backend_group"
    storage_account_name = "fpplusstorageaccount"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
  }
  subscription_id = "fbe7b0f0-7cb6-44b3-8353-9ad095122ce3"
}
