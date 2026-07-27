terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Resource Group 
resource "azurerm_resource_group" "terraform-rg" {
  name     = var.resource_group_name
  location = var.location
}

# Vnet creation 
resource "azurerm_virtual_network" "terraform-vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.terraform-rg.location
  resource_group_name = azurerm_resource_group.terraform-rg.name
  address_space       = var.vnet_address_space
}

# Create Subnet
resource "azurerm_subnet" "terraform-subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.terraform-rg.name
  virtual_network_name = azurerm_virtual_network.terraform-vnet.name
  address_prefixes     = var.subnet_address_prefixes
}

# IP
resource "azurerm_public_ip" "terraform-ip" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.terraform-rg.name
  location            = azurerm_resource_group.terraform-rg.location
  allocation_method   = var.public_ip_allocation_method
}

# NSG creation
resource "azurerm_network_security_group" "terraform-nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.terraform-rg.location
  resource_group_name = azurerm_resource_group.terraform-rg.name
}

# NSG Rule (To Open Port 80)
resource "azurerm_network_security_rule" "allowhttp" {
  name                        = "AllowHTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.terraform-rg.name
  network_security_group_name = azurerm_network_security_group.terraform-nsg.name
}

# NSG rule for Port 22 (SSH)
resource "azurerm_network_security_rule" "allowssh" {
  name                        = "AllowSSH"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.terraform-rg.name
  network_security_group_name = azurerm_network_security_group.terraform-nsg.name
}

# NIC for the VM 
resource "azurerm_network_interface" "terraform-nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.terraform-rg.location
  resource_group_name = azurerm_resource_group.terraform-rg.name

  ip_configuration {
    name                          = "terra-ip"
    subnet_id                     = azurerm_subnet.terraform-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.terraform-ip.id
  }
}

# NIC Association 
resource "azurerm_network_interface_security_group_association" "terra-nic-asso" {
  network_interface_id      = azurerm_network_interface.terraform-nic.id
  network_security_group_id = azurerm_network_security_group.terraform-nsg.id
}

# Linux VM Creation
resource "azurerm_linux_virtual_machine" "terraform-vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.terraform-rg.name
  location            = azurerm_resource_group.terraform-rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.terraform-nic.id
  ]
  disable_password_authentication = true
  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}    