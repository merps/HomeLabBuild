provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url        = var.pm_api_url
  pm_password       = var.pm_password
  pm_user           = var.pm_user
}

module "k8scluster" {
  source = ".//modules/k8scluster"

  name_prefix = "k8s-node"
  ips = [
    "192.168.1.141",
    "192.168.1.142"
    #"192.168.1.143",
  ]

  sshkeys = <<EOF
${var.ssh_key}
EOF

  gateway = "192.168.1.1"
  bridge = "vmbr0"
  storage_size = "80G"
  storage_pool = "local-lvm"
  target_node = "mando"
}
