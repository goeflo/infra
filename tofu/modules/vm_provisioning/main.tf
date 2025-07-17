# main.tf (in modules/vm_provisioning)

variable "proxmox_node" {}
variable "vm_storage" {}
variable "vm_name" {}
variable "vm_id" {}
variable "vm_cores" { type = number }
variable "vm_memory" { type = number }
variable "network_bridge" {}
variable "cloud_init_user_data" { default = null } 
variable "source_template_id" { type = number }
variable "tags" { default = ["opentofu", "debian"] }
variable "vm_description" {}
variable "ipv4_address" {}
variable "dns_servers" {}
variable "gateway" {}
variable "dns_domain" {}
variable "ssh_key" {}
variable "vm_user" {}

terraform {
    required_providers {
        proxmox = {
            source  = "bpg/proxmox"
            version = "~> 0.80" # Match root module version
        }
    }
}


resource "proxmox_virtual_environment_vm" "cloned_vm" {

    name = var.vm_name
    node_name = var.proxmox_node
    vm_id = var.vm_id
    description = var.vm_description
    tags = var.tags

    agent {
        enabled = true
    }

    clone {
        vm_id = var.source_template_id
        full = true
    }

    cpu {
        cores = var.vm_cores
    }

    memory {
        dedicated = var.vm_memory
    }

    initialization {
        datastore_id = var.vm_storage
        
        ip_config {
            ipv4 {
              address = var.ipv4_address
              gateway = var.gateway
            }
        }

        dns {
            servers = var.dns_servers
            domain = var.dns_domain
        }

        user_account {
            username = var.vm_user
            keys = var.ssh_key
        }
    }
}