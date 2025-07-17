# outputs.tf  in (modules/vm_template/)

# the vm id is passed in as parameter,
# but output the vm id for depency checks.
output "vm_id" {
    value = proxmox_virtual_environment_vm.debian_template.vm_id
}