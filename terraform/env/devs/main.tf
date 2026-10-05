data "terraform_remote_state" "base" {
  backend = "local"
  config = {
    path = "${path.module}/../../base/terraform.tfstate"
  }
}

resource "proxmox_virtual_environment_vm" "test" {
  name            = "fiduce-dev-test"
  node_name       = var.node_name
  tags            = ["dev", "fiduce", "terraform"]
  stop_on_destroy = true

  agent {
    enabled = false
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = "local-lvm"
    import_from  = data.terraform_remote_state.base.outputs.debian_image_id
    interface    = "scsi0"
    size         = 20
    discard      = "on"
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
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