terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.7.4"
    }
  }
}

provider "proxmox" {
  #pm_api_url = "https://172.22.6.144:8006/api2/json"
  pm_api_url = "https://192.168.1.188:8006/api2/json"
  pm_api_token_id = "kube@pam!kubetoken"
  pm_api_token_secret = "9e156aa5-09fd-47d9-a58d-8ac8627cb789"
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "master" {
  count = 1
  name = "master-0${count.index + 1}"
  target_node = "proxmox"

  clone = "template"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "10G"
    type = "scsi"
    storage = "drive"
    iothread = 1
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.1.11${count.index + 1}/24,gw=192.168.1.1"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "worker" {
  count = 2
  name = "worker-0${count.index + 1}"
  target_node = "proxmox"

  clone = "template"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "10G"
    type = "scsi"
    storage = "drive"
    iothread = 1
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.1.12${count.index + 1}/24,gw=192.168.1.1"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

 resource "proxmox_vm_qemu" "storage" {
   count = 1
   name = "storage-0${count.index + 1}"
   target_node = "proxmox"

   clone = "template"

   agent = 1
   os_type = "cloud-init"
   cores = 2
   sockets = 1
   cpu = "host"
   memory = 512
   scsihw = "virtio-scsi-pci"
   bootdisk = "scsi0"

   disk {
     slot = 0
     size = "10G"
     type = "scsi"
     storage = "drive"
     iothread = 1
   }

   network {
     model = "virtio"
     bridge = "vmbr0"
   }
  

   lifecycle {
     ignore_changes = [
       network,
     ]
   }

   ipconfig0 = "ip=192.168.1.20${count.index + 1}/24,gw=192.168.1.1"
   sshkeys = <<EOF
   ${var.ssh_key}
   EOF
 }

  resource "proxmox_vm_qemu" "loadbalancer" {
   count = 1
   name = "loadbalancer-0${count.index + 1}"
   target_node = "proxmox"

   clone = "template"

   agent = 1
   os_type = "cloud-init"
   cores = 2
   sockets = 1
   cpu = "host"
   memory = 512
   scsihw = "virtio-scsi-pci"
   bootdisk = "scsi0"

   disk {
     slot = 0
     size = "4G"
     type = "scsi"
     storage = "drive"
     iothread = 1
   }

   network {
     model = "virtio"
     bridge = "vmbr0"
   }
  

   lifecycle {
     ignore_changes = [
       network,
     ]
   }

   ipconfig0 = "ip=192.168.1.7${count.index + 1}/24,gw=192.168.1.1"
   sshkeys = <<EOF
   ${var.ssh_key}
   EOF
 }