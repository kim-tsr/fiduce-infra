variable "name" {type = string }
variable "node_name" {type = string }
variable "vm_id" {type = string }
variable "ip" {type = string }
variable "gateway" {type = string }
variable "ssh_public_key" {type = string }
variable "datastore_id" {type = string }


variable "cores" {
  type = number
  default = 2
}

variable "memory" {
  type = number
  default = 2048
}

variable "storage" {
  type = number
  default = 20
}

variable "tags" {
  type = list(string)
  default = []
}