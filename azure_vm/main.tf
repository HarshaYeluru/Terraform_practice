provider "azurerm" {
  features {}

  subscription_id    = "79d6c887-2a85-4cf3-91e4-934402cfbce9"
}

resource "azurerm_resource_group" "second_rg" {
    name = "second_rg"
    location = "Central US"
}

resource "azurerm_network_interface" "main" {
  name                = "first-nic"
  location            = "Central US"
  resource_group_name = "second_rg"

    ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "first-network"
  address_space       = ["10.0.0.0/16"]
  location            = "Central US"
  resource_group_name = "second_rg"
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "second_rg"
  virtual_network_name = "first-network"
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_virtual_machine" "main" {
  name                  = "first-vm"
  location              = "Central US"
  resource_group_name   = "second_rg"
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true
    storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}