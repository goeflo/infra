terraform {
    required_version = ">= 1.6.0" # Or your desired minimum version

    required_providers {
        proxmox = {
            source  = "bpg/proxmox"
            version = "~> 0.80" 
        }
    }
}

provider "proxmox" {

    endpoint = var.proxmox_endpoint
    api_token = var.proxmox_api_token
    insecure = true

    ssh {
        username = var.proxmox_ssh_username
        agent = true
    }
    
}