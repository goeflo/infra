# variables.tf (in root)
variable "proxmox_endpoint" {
  description = "Proxmox API endpoint URL"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token for authentication"
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_username" {
  description = "SSH username for Proxmox node access"
  type        = string
}

variable "proxmox_ssh_password" {
  description = "SSH username for Proxmox node access"
  type        = string
  sensitive = true
}

variable "proxmox_ssh_private_key" {
  description = "Path to the SSH private key for Proxmox node access"
  type        = string
}

variable "default_proxmox_node" {
  description = "Default Proxmox node name"
  type        = string
}

variable "default_vm_storage" {
  description = "Default storage pool for VM disks"
  type        = string
}

variable "default_zfs_storage" {
  description = "Default storage pool for disk images"
  type        = string
}

variable "default_iso_storage" {
  description = "Default storage pool for ISOs/templates"
  type        = string
}

variable "default_proxmox_node_ssh_ip" {
  description = "IP address for SSH connection to the Proxmox node (if different from API endpoint hostname/IP)"
  type        = string
  default     = "" # Set a default or provide in tfvars
}

variable "default_vm_user" {
  description = "Default vm User name"
  type        = string
}