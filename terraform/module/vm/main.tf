data "terraform_remote_state" "base" {
  backend = "local"
  config = {
    path = "${path.module}/../../base/terraform.tfstate"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name            = var.name
  node_name       = var.node_name
  vm_id           = var.vm_id
  tags            = sort(var.tags)
  stop_on_destroy = true

  agent {
    enabled = true
  }

  cpu {
    cores = var.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.datastore_id
    import_from  = data.terraform_remote_state.base.outputs.debian_image_id
    interface    = "scsi0"
    size         = var.storage
    discard      = "on"
  }

  network_device {
    bridge = "vmbr1"
  }

  initialization {
    datastore_id = var.datastore_id
    ip_config {
      ipv4 {
        address = "${var.ip}/24"
        gateway = var.gateway
      }
    }
    user_account {
      username = "ansible"
      keys     = [var.ssh_public_key]
    }
  }

  operating_system {
    type = "l26"
  }

  serial_device {}
}