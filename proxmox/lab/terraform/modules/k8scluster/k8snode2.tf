#===============================================================================
# Proxmox Node Creation
#===============================================================================

resource "null_resource" "previous" {}

resource "time_sleep" "wait_2_mins" {
  depends_on = [null_resource.previous]

  create_duration = "120s"
}


# Create the Proxmox Nodes #
resource "proxmox_vm_qemu" "k8snode2" {

  #count = length(192.168.1.142)

  #name = "${var.node_name}" + count.index
  name = "K8s-node-2"
  desc = "terraform-created vm"
  target_node = "mando"

  clone = "debian-10-template"

  cores = 2
  sockets = 1
  memory = 4096

	disk {
		id = 0
		type = "virtio"
		storage = "local-lvm"
		size = "80G"
	}

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr0"
  }

  ssh_user = "root"

  os_type = "cloud-init"
  #ipconfig0 = "ip=${"${192.168.1.142}" + count.index}/24,gw=192.168.1.1"
  ipconfig0 = "ip=192.168.1.142/24,gw=192.168.1.1"

  sshkeys = var.sshkeys

    provisioner "remote-exec" {
        inline = [
            "${data.external.kubeadm_join.result.command}"
        ]
        connection {
            type     = "ssh"
            user     = "root"
            password = "default"
            host = "192.168.1.142"
        }
    }
}