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

# set some default values

variable "default_proxmox_node" {
  description = "Default Proxmox node name"
  type = string
  default = "magnix"
}

variable "default_vm_storage" {
  description = "Default storage pool for VM disks"
  type = string
  default = "local-zfs"
}

variable "default_zfs_storage" {
  description = "Default storage pool for disk images"
  type = string
  default = "local-zfs"
}

variable "default_iso_storage" {
  description = "Default storage pool for ISOs/templates"
  type = string
  default = "nfs"
}

variable "default_vm_user" {
  description = "Default vm User name"
  type = string
  default = "florian"
}

variable "default_dns_domain" {
  description = "global DNS domain suffix"
  type = string
  default = "home.peekingface.eu"
}