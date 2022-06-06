provider "azurerm" {
  features {}

  subscription_id    = "79d6c887-2a85-4cf3-91e4-934402cfbce9"
  client_id          = "4b812d4d-3ad2-4fb8-930e-f4044fca31df"
  tenant_id          = "d7f4ead7-babc-42f8-98e9-6942cffa90b2"
}

resource "azurerm_resource_group" "first_rg" {
    name = "first_rg"
    location = "Central US"
}