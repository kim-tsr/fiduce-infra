locals {
  nodes = {
    "fiduce-control"  = { vm_id = 100, ip = "10.10.20.101", gateway = "10.10.20.1", cores = 2, memory = 4096, role = "server" }
    "fiduce-worker-1" = { vm_id = 101, ip = "10.10.20.102", gateway = "10.10.20.1", cores = 4, memory = 2048, role = "agent" }
    "fiduce-worker-2" = { vm_id = 102, ip = "10.10.20.103", gateway = "10.10.20.1", cores = 4, memory = 2048, role = "agent" }
  }
}

module "node" {
  source         = "../../module/vm"
  for_each       = local.nodes
  name           = each.key
  node_name      = var.node_name
  ip             = each.value.ip
  gateway        = each.value.gateway
  ssh_public_key = var.ssh_public_key
  cores          = each.value.cores
  memory         = each.value.memory
  tags           = ["fiduce", "k3s", each.value.role]
  vm_id          = each.value.vm_id
  datastore_id   = "vmdata"
}

resource "local_file" "hosts" {
  filename = "${path.module}/../../../ansible/inventories/dev/hosts.yml"
  content  = templatefile("${path.module}/inventory.yml.tftpl", {nodes = local.nodes})
}