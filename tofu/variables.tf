# variables.tf (in root)

variable "dns_servers_config" {
  description = "map of dns server configuration"
  type = map(object({
    proxmox_node = string
    vm_name = string
    vm_description = string
    ipv4_address_with_cidr = string
    #dns_servers = list(string)
  }))
  default = {
    "dns-01" = {
      proxmox_node = "magnix"
      vm_name = "dns-01"
      vm_description = "primary dns server"
      ipv4_address_with_cidr = "192.168.2.7/24"
      source_template_id = 9001
      #dns_servers = ["1.1.1.1"] # using public dns to install local dns
    }
    "dns-02" = {
      proxmox_node = "magnix"
      vm_name = "dns-02"
      vm_description = "secondary dns server"
      ipv4_address_with_cidr = "192.168.2.8/24" 
      source_template_id = 9001
      #dns_servers = ["1.1.1.1"] # using public dns to install local dns
    }
  }
}


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
  #default = "192.168.2.20"
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