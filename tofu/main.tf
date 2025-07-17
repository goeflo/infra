# main.tf 

module "debian_template" {
    source = "./modules/vm_template"
    proxmox_node = var.default_proxmox_node
    vm_storage = var.default_vm_storage
    iso_storage = var.default_iso_storage
    zfs_storage = var.default_zfs_storage
    cloud_image_url = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
    image_file_name = "debian-12-genericcloud-amd64.qcow2"
    vm_template_name = "debian-12-cloud-template"
    vm_template_id = 9001
    vm_user = var.default_vm_user
    ssh_password = var.proxmox_ssh_password
    ssh_username = var.proxmox_ssh_username
}

module "dns_server" {
    source = "./modules/vm_provisioning"
    proxmox_node = var.default_proxmox_node
    vm_storage = var.default_vm_storage

    # depency checking via template id
    source_template_id = module.debian_template.vm_id

    vm_name = "dns-01"
    vm_description = "dns server"
    tags = ["opentofu", "debian", "dns"]
    vm_id = 300
    vm_cores = 1
    vm_memory = 2048 # 2GB
    network_bridge = ""
    ipv4_address = "192.168.2.7/24"
    dns_servers = ["192.168.2.7"]
    gateway = "192.168.2.1"
    dns_domain = "home.bensemer.name"
    cloud_init_user_data = ""
    ssh_key = [file("~/.ssh/id_rsa.pub")]
    vm_user = var.default_vm_user
}
