#
#terraform {
#    required_version = ">= 0.13.4"
#    required_providers {
#    proxmox = {
#        source = "bpg/proxmox"
#        version = "~> 0.78"
#    }
##    pihole = {
##        source = "iolave/pihole"
##    }
#  }
#}
#
##variable "pihole_url" {
##    type = string
##}
#
##variable "pihole_password" {
##    type = string
##    sensitive = true
##}
#
#variable "proxmox_url" { 
#    type = string
#}
#
#variable "proxmox_api_token" { 
#    type = string
#    sensitive = true
#}
#
#provider "proxmox" {
#    endpoint = var.proxmox_url
#    api_token = var.proxmox_api_token
#    insecure = true
#    ssh {
#        username = "root"
#        agent = true
#    }
#}
#
##provider "pihole" {
##    url = var.pihole_url
##    password = var.pihole_password
##}