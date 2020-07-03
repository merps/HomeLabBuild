resource "proxmox_vm_qemu" "generic-vm" {
  count = length(var.ips)

  name = "${var.node_name}"
  desc = "terraform-created vm"
  target_node = "mando"

  clone = "ubuntu-ci"

  cores = 2
  sockets = 1
  memory = 4096

	disk {
		id = 0
		type = "scsi"
		storage = "local-lvm"
		size = "80G"
	}

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr0"
  }

  ssh_user = "ubuntu"

  os_type = "cloud-init"
  ipconfig0 = "ip=${var.main_ip}/24,gw=192.168.1.1"

  sshkeys = <<EOF
      "private ssh key"
EOF
}
