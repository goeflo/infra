# main.tf 

module "debian_template" {
    source = "./modules/vm_template"
    proxmox_node = var.default_proxmox_node
    dns_domain = var.default_dns_domain
    vm_storage = var.default_vm_storage
    iso_storage = var.default_iso_storage
    zfs_storage = var.default_iso_storage
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

    # iterate over map defined in var.dns_servers_config
    for_each = var.dns_servers_config

    proxmox_node = each.value.proxmox_node
    vm_storage = var.default_vm_storage

    # depency checking via template id
    source_template_id = module.debian_template.vm_id
    
    vm_name = each.value.vm_name
    vm_description = each.value.vm_description
    tags = ["opentofu", "debian", "dns"]
    vm_cores = 2
    vm_memory = 2048 # 2GB
    network_bridge = ""
    ipv4_address_with_cidr = each.value.ipv4_address_with_cidr
    dns_servers = ["1.1.1.1"] # using public dns to install local dns
    gateway = "192.168.2.1"
    dns_domain = var.default_dns_domain
    ssh_key = [file("~/.ssh/id_rsa.pub")]
    vm_user = var.default_vm_user
}

module "docker_server" {
    source = "./modules/vm_provisioning"
    proxmox_node = var.default_proxmox_node
    vm_storage = var.default_vm_storage

    # depency checking via template id
    source_template_id = module.debian_template.vm_id
    
    vm_name = "dockerix"
    vm_description = "docker server"
    tags = ["opentofu", "debian", "docker"]
    vm_cores = 2
    vm_memory = 4096 # 4GB
    network_bridge = ""
    ipv4_address_with_cidr = "192.168.2.190/24"
    dns_servers = ["192.168.2.7"]
    gateway = "192.168.2.1"
    dns_domain = var.default_dns_domain
    ssh_key = [file("~/.ssh/id_rsa.pub")]
    vm_user = var.default_vm_user
}

module "immich_server" {
    source = "./modules/vm_provisioning"
    proxmox_node = var.default_proxmox_node
    vm_storage = var.default_vm_storage

    # depency checking via template id
    source_template_id = module.debian_template.vm_id
    
    vm_name = "immich"
    vm_description = "immich server"
    tags = ["opentofu", "debian", "docker"]
    vm_cores = 2
    vm_memory = 4096 # 4GB
    network_bridge = ""
    ipv4_address_with_cidr = "192.168.2.191/24"
    dns_servers = ["192.168.2.7"]
    gateway = "192.168.2.1"
    dns_domain = var.default_dns_domain
    ssh_key = [file("~/.ssh/id_rsa.pub")]
    vm_user = var.default_vm_user
}
