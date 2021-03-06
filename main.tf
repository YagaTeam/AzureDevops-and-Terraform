terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.45.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tf_rg_blobstore"
    storage_account_name = "tfstoreacc"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {

  }
}
resource "azurerm_resource_group" "tf_test" {
  name     = "tfmainrg"
  location = "Germany West Central"
}

variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}
resource "azurerm_container_group" "tfcg_test" {
  name                = "weatherapi"
  location            = azurerm_resource_group.tf_test.location
  resource_group_name = azurerm_resource_group.tf_test.name

  ip_address_type = "public"
  dns_name_label  = "phaenir"
  os_type         = "Linux"

  container {
    name   = "weatherapi"
    image  = "phaenir/weatherapi:${var.imagebuild}"
    cpu    = "1"
    memory = "1"

    ports {
      port     = "80"
      protocol = "TCP"
    }
  }
}
