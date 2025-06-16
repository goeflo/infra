# main.tf 

locals {
    common_vm_config = {
        stop_on_destroy = true
        agent_enabled = false
        cpu_type = "x86-64-v2-AES"
        disk_storage_id = "local-zfs"
        disk_interface = "scsi0"
        network_bridge = "vmbr0"
        ipv4_gateway = "192.168.2.1"
        dns_domain = "bensemer.name"
    }

    vms = {
        "dns-01" = {
            vm_id = 200
            node_name = "magnix"
            tags = ["debian", "opentofu", "dns"]
            description = "dns server"
            ipv4_address = "192.168.2.6/24"
            dns_servers = ["192.168.2.6"]
            cpu_cores = 1
            disk_size = 3
            memory_dedicated = 2048
            memory_floating = 2048
            clone_id = 9000
            initialization_username = "florian"
            initialization_user_keys = [file("~/.ssh/id_rsa.pub")]
        }
        "salamix" = {
            vm_id = 201
            node_name = "magnix"
            tags = ["debian", "opentofu", "docker"]
            description = "debian docker server"
            ipv4_address = "192.168.2.201/24"
            dns_servers = ["192.168.2.6"]
            cpu_cores = 2
            disk_size = 10
            memory_dedicated = 4096
            memory_floating = 4096
            clone_id = 9000
            initialization_username = "florian"
            initialization_user_keys = [file("~/.ssh/id_rsa.pub")]
        }
    }  
}

resource "proxmox_virtual_environment_vm" "vms" {

    for_each = local.vms

    name = each.key
    node_name = each.value.node_name
    vm_id = each.value.vm_id
    description = each.value.description
    tags = each.value.tags
    stop_on_destroy = local.common_vm_config.stop_on_destroy

    agent {
      enabled = local.common_vm_config.agent_enabled
    }

    cpu {
        cores = 1
        type = local.common_vm_config.cpu_type
    }

    memory {
        dedicated = each.value.memory_dedicated
        floating = each.value.memory_floating
    }

    disk {
        datastore_id = local.common_vm_config.disk_storage_id
        size = each.value.disk_size
        interface = local.common_vm_config.disk_interface
    }

    clone {
        vm_id = each.value.clone_id
    }

    network_device {
        bridge = local.common_vm_config.network_bridge
    }

    initialization {
        datastore_id = local.common_vm_config.disk_storage_id
        ip_config {
            ipv4 {
                address = each.value.ipv4_address
                gateway = local.common_vm_config.ipv4_gateway
            }
        }
        dns {
            servers = each.value.dns_servers
            domain = local.common_vm_config.dns_domain
        }
        user_account {
            username = each.value.initialization_username
            keys = each.value.initialization_user_keys
        }
    }
}
