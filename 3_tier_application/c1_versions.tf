# For more informatio check the following documentation
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
# Azure Provider source and version being used
terraform {
  required_version = "~> 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # Taking latest version of arure provider
      version = "~> 3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "3-tier-app-rg" # Required
  location = var.location-rg # Required
  tags = {
    "Application" = "3tier_app"
  }
}