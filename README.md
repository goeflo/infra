# infra

## opentofu

tofo.auto.tfvars content

```
proxmox_url = "https://127.0.0.1:8006/api2/json"
proxmox_api_token = "xxxxx"
```


1. `tofu init`
2. `tofu plan`
3. `tofu apply`

### remove a specific vm

`tofu destroy -target='proxmox_virtual_environment_vm.vms["dns-01"]'`
