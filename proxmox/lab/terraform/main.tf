provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url        = var.pm_api_url
  pm_password       = var.pm_password
  pm_user           = var.pm_user
}