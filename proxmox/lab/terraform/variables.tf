variable "pm_api_url" {
  type = string
}
variable "pm_user" {
  type = string
}
variable "pm_password" {
  type = string
}
variable "cores" {
  description = "number of cores to give each vm"
  type = number
}

variable "memory" {
  description = "amount of memory in MB give each vm"
  type = number
}

variable "sshkeys" {
  description = "ssh keys to drop onto each vm"
  type = string
}

variable "ssh_user" {
  description = "user to put ssh keys under"
  type = string
}

variable "gateway" {
  description = "gateway for cluster"
  type = string
}

variable "bridge" {
  description = "bridge to use for network"
  type = string
}

variable "storage_size" {
  description = "amount of storage to give nodes"
  type = string
}

variable "storage_pool" {
  description = "storage pool to use for disk"
  type = string
}

variable "target_node" {
  description = "node to deploy on"
  type = string
}

variable "template_name" {
  description = "template to use"
  type = string
}
variable "proxmox_k8pod_network" {
  description = "POD Network and Subnet Mask for K8 Configruation Script"
}
variable "proxmox_k8_nodes" {
  type = number
}
variable "node_name" {
  description = "VM name"
  type        = string
}
variable "leader_ip" {
  description = "Main IP for K8s Leader Node"
  type        = string
}