# main.tf (in modules/vm_template)

variable "image_file_name" { type = string }
variable "zfs_storage" { type = string }
variable "vm_storage" { type = string }
variable "vm_template_name" { type = string }
variable "proxmox_node" { type = string }
variable "iso_storage" { type = string }
variable "cloud_image_url" { type = string }
variable "vm_template_id" { type = string }
variable "vm_user" { type = string }
variable "ssh_password" { type = string }
variable "ssh_username" { type = string }

terraform {
    required_providers {
        proxmox = {
            source  = "bpg/proxmox"
            version = "~> 0.80" # Match root module version
        }
    }
}

# Step 1: download the qcow2 image
resource "proxmox_virtual_environment_file" "debian_qcow2_download" {
    content_type = "import"
    datastore_id = var.iso_storage
    node_name = var.proxmox_node
    #overwrite = true

    source_file {
        path = var.cloud_image_url
        insecure = true
    }
}

# stop 2: create the VM template
resource "proxmox_virtual_environment_vm" "debian_template" {

    # first download qcow debian image
    depends_on = [proxmox_virtual_environment_file.debian_qcow2_download]

    name = var.vm_template_name
    node_name = var.proxmox_node
    vm_id = var.vm_template_id
    description = "debian 12 klaut-init template for opentofu"
    tags = ["opentofu", "debian", "template"]
    template = true
    on_boot = false
    started = false

    cpu { 
        cores = 1
        type = "host"
    }
    
    memory { 
        dedicated = 2048
    }

#    disk {
#        datastore_id = var.vm_storage
#        size = 1 # Placeholder disk
#        interface = "scsi0"
#    }

    network_device { 
        model = "virtio"
        bridge = "vmbr0" 
    }

    initialization {
        datastore_id = var.vm_storage
    }

    connection {
        type = "ssh"
        user = var.ssh_username
        host = var.proxmox_node
        password = var.ssh_password
    }

    provisioner "remote-exec" {
        inline = [
            "QCOW2_PATH=$(pvesm path ${var.iso_storage}:import/${var.image_file_name})",
            "qm importdisk ${self.vm_id} $QCOW2_PATH ${var.vm_storage}",
            "qm set ${self.vm_id} -scsi0 ${var.vm_storage}:vm-${var.vm_template_id}-disk-0,ssd=1,discard=on,size=32G",
            "qm set ${self.vm_id} -boot order=scsi0",
            "qm set ${self.vm_id} -ide2 ${var.vm_storage}:cloudinit",
            "qm set ${self.vm_id} --agent 1"
        ]
    }

# "qm set ${self.vm_id} -ipconfig0 ip=dhcp",

}
