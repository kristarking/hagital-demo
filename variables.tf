variable "subscription_id" {
  description = "70faaaeb-e126-4ca7-95be-9e614709f37b"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "terraform-rg"
}

variable "location" {
  description = "Azure region to deploy into"
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "terraform-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "terraform-subnet"
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "public_ip_name" {
  description = "Name of the public IP resource"
  type        = string
  default     = "terraform-ip"
}

variable "public_ip_allocation_method" {
  description = "Static or Dynamic allocation for the public IP"
  type        = string
  default     = "Static"
}

variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
  default     = "terraform-nsg"
}

variable "nic_name" {
  description = "Name of the network interface"
  type        = string
  default     = "terraform-nic"
}

variable "vm_name" {
  description = "Name of the Linux virtual machine"
  type        = string
  default     = "terraform-vm"
}

variable "vm_size" {
  description = "Azure VM size (SKU)"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the Linux VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the local SSH public key used to log into the VM"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
