locals {
  nodes = {
    "fiduce-control"  = { ip = "10.10.20.101", gateway = "10.10.20.1", cores = 2, memory = 4096, role = "control" }
    "fiduce-worker-1" = { ip = "10.10.20.102", gateway = "10.10.20.1", cores = 4, memory = 2048, role = "worker" }
    "fiduce-worker-2" = { ip = "10.10.20.103", gateway = "10.10.20.1", cores = 4, memory = 2048, role = "worker" }
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
}