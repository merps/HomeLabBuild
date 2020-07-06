variable "pm_api_url" {
  default = "https://192.168.1.250:8006/api2/json"
}
variable "pm_user" {
default = "root@pam"
}
variable "pm_password" {
default = "default"
}
variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUMACmb30ibzLXL0YmzObJZEzyjfOVNTwVo9wVCwkvQtigKbPlmc+WPY9O1+VDTAIdLua/bIESYtQmWoVy48/Zz+nBgF9+RsqM1P6FXW/s5y3P0fbsoqCbLKP9uM3b2lLKnwzfzDvWBvjjLsMPW6AG6uStj087t+l5kQMo1fvc/lEclddYrL/SIoebZrslflA0ZHdXr4RTgKIX4V6zcnBN/Yc4xwd8FtEyovn7ibZz4ZuKHi6Ff9M/hfD6z1HHbqgLWQacv4uTf4rw5Wsu8dtYO9+wZbFpCHc7q+eNi9rO2O0/QsJ0KGMmNn4BegLevZwju9x8Q/J4UGhBlKAgOCGN root@pve00"
}
variable "proxmox_k8_nodes" {
  default = 2
}
variable "proxmox_k8pod_network" {
  description = "POD Network and Subnet Mask for K8 Configruation Script"
  default = "10.30.0.0/16"
}