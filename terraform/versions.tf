terraform {
  required_version = "~> 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Backend remoto recomendado para trabalho em equipe
  # Descomente e configure conforme seu ambiente
  # backend "azurerm" {
  #   resource_group_name  = "terraform-state-rg"
  #   storage_account_name = "tfstatestorage"
  #   container_name       = "tfstate"
  #   key                  = "webapp.terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
}
