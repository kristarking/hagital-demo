output "vm_public_ip" {
  description = "Public IP address of the Terraform VM"
  value       = azurerm_public_ip.terraform-ip.ip_address
}

output "vm_private_ip" {
  description = "Private IP address assigned to the VM's NIC"
  value       = azurerm_network_interface.terraform-nic.private_ip_address
}

output "resource_group_name" {
  description = "Name of the resource group that holds all resources"
  value       = azurerm_resource_group.terraform-rg.name
}

output "vm_name" {
  description = "Name of the deployed virtual machine"
  value       = azurerm_linux_virtual_machine.terraform-vm.name
}

output "ssh_connection_command" {
  description = "Ready-to-use SSH command for connecting to the VM"
  value       = "ssh ${azurerm_linux_virtual_machine.terraform-vm.admin_username}@${azurerm_public_ip.terraform-ip.ip_address}"
}