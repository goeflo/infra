# main.tf (in modules/vm_provisioning)

variable "proxmox_node" { nullable = false }
variable "vm_storage" { nullable = false }
variable "vm_name" { nullable = false }
#variable "vm_id" { nullable = false }
variable "network_bridge" {}
variable "source_template_id" { type = number }
variable "tags" { default = ["opentofu", "debian"] }
variable "vm_description" {}
variable "ipv4_address_with_cidr" { nullable = false }
variable "dns_servers" { nullable = false }
variable "gateway" { nullable = false }
variable "dns_domain" { nullable = false }
variable "ssh_key" { nullable = false }
variable "vm_user" { nullable = false }

variable "vm_cores" { 
    type = number
    default = 1 
}

variable "vm_memory" { 
    type = number 
    default = 2048
}

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
    vm_id = local.proxmox_id_numeric
    description = var.vm_description
    tags = var.tags
    stop_on_destroy = true
    
    agent {
        enabled = false
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
              address = var.ipv4_address_with_cidr
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

    # remove invalid ssh host entries
    provisioner "local-exec" {
        command = "ssh-keygen -R ${local.ip_address}"
        on_failure = continue
    }
}

locals {
    # split 192.168.2.200/25 
    ip_parts = split("/", var.ipv4_address_with_cidr)
    ip_address = element(local.ip_parts, 0)

    last_octet_string = element(split(".", local.ip_address), length(split(".", local.ip_address)) - 1)
    last_octet_number = tonumber(local.last_octet_string)

    muliplier = pow(10, 4 - length(local.last_octet_string))
    proxmox_id_numeric = local.last_octet_number * local.muliplier    
}