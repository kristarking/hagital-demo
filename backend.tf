terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "krisking2026"
    container_name       = "tfstate"
    key                  = "terraform-project.tfstate"
  }
}
