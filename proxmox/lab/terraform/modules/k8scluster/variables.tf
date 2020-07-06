variable "ips" {
  description = "List of IPs for cluster nodes"
  type        = list(string)
}

variable "name_prefix" {
  description = "Prefix for node names"
  type = string
}

variable "cores" {
  description = "number of cores to give each vm"
  type = number
  default = 2
}

variable "memory" {
  description = "amount of memory in MB give each vm"
  type = number
  default = 4096
}

variable "sshkeys" {
  description = "ssh keys to drop onto each vm"
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpf5QVzQDYxhceqoeOhKF+Z92bvpxasLqB6KEU9d3+ae7vXKVueA70CCBDir89nkJ0WFLLVC8xNT9Gdr4dE1d1KoNjBmDqIlaCxJbRy0UsYPSO/D8o271ILv6PagW9r/cWdxXPVJmAYSYMXgXcpAs+95KT6hCefbBAdplmGABnzsY8DRc1C+fFZp1duW8OWuoMwBlO0hmG1MwghCPTLGQm8RgYnYdoy7GA5dz4n5oKSNc2tHjaq21Zr9m1PlSmx3ew5iHMlwOCsH5Fk5l4MJbEDw9KPAS0ETMHg9d4fLnQKnM2F2HjOsw9dgegCYxmL5JI46LzRxEoAsxrqQuBDbZM1g9gT/58r7xU02PfIXVQSNciGoZrZCmeVCnUhEXhkoxVTOXltpTMufRSw5g9ha1XkMHAXcFhPQddIrh+ATJYEPzOCVe/QNY7XnyuFrWv96Or9hEprR6DThEkbX8fnGIRQih8zHNVF94lbaxgcjllaqtTt4ySgApYrJrn/SmWEScFLq5cBrvMcvPc+Hvny8jDsPgulzGQetxaflZ7CwGLMYHUo+SXI1ytrmsBlgvTSH4IUvY5XmlknuOIbwctL30M1xaeNkVLJcOWY2/XP9ImOtwdFgHC5iE61N9cf3jFF3RLpa9+/JBzEGOwZ7miq0h500UxX8hpiiIgg3cxCDctlw== jarrodl@SYD-L-00033925"
}

variable "ssh_user" {
  description = "user to put ssh keys under"
  type = string
  default = "ubuntu"
}

variable "gateway" {
  description = "gateway for cluster"
  type = string
}

variable "bridge" {
  description = "bridge to use for network"
  type = string
  default = "vmbr0"
}

variable "storage_size" {
  description = "amount of storage to give nodes"
  type = string
  default = "80G"
}

variable "storage_pool" {
  description = "storage pool to use for disk"
  type = string
  default = "local-lvm"
}

variable "target_node" {
  description = "node to deploy on"
  type = string
}

variable "template_name" {
  description = "template to use"
  type = string
  default = "ubuntu-ci"
}
variable "proxmox_k8pod_network" {
  description = "POD Network and Subnet Mask for K8 Configruation Script"
  default = "10.30.0.0/16"
}
variable "proxmox_k8_nodes" {
  default = 2
}
variable "node_name" {
  description = "VM name"
  type        = string
  default = "K8s-node"
}