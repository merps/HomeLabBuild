#===============================================================================
# Proxmox Node Creation
#===============================================================================

resource "null_resource" "previous" {}

resource "time_sleep" "wait_2_mins" {
  depends_on = [null_resource.previous]

  create_duration = "120s"
}


# Create a vSphere VM in the folder #
resource "vsphere_virtual_machine" "k8snode" {

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

  sshkeys = var.ssh_key
  #sshkeys = <<EOF
  #    "private ssh key"
#EOF

provisioner "file" {
        source      = "configurek8node_phase1.sh"
        destination = "/tmp/configurek8node_phase1.sh"

        connection {
            type     = "ssh"
            user     = "root"
            #password = var.vsphere_vm_password 
            host = "${var.main_ip}"
        }
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/configurek8node_phase1.sh",
            "/tmp/configurek8node_phase1.sh",
        ]
        connection {
            type     = "ssh"
            user     = "root"
            #password = var.vsphere_vm_password 
            host = "${var.main_ip}"     
        }
    }
    provisioner "remote-exec" {
        inline = [
            "yum install -y docker kubelet kubeadm kubectl --disableexcludes=kubernetes"
        ]
      
        connection {
            type     = "ssh"
            user     = "root"
            #password = var.vsphere_vm_password
            host = "${var.main_ip}"
        }
    }
    provisioner "file" {
        source      = "configurek8node_phase2.sh"
        destination = "/tmp/configurek8node_phase2.sh"

        connection {
            type     = "ssh"
            user     = "root"
            #password = var.vsphere_vm_password
            host = "${var.main_ip}"
        }
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/configurek8node_phase2.sh",
            "/tmp/configurek8node_phase2.sh",
        ]
        connection {
            type     = "ssh"
            user     = "root"
            #password = var.vsphere_vm_password
            host = "${var.main_ip}"
        }
    }
    provisioner "remote-exec" {
        inline = [
            "${data.external.kubeadm_join.result.command}"
        ]
        connection {
            type     = "ssh"
            user     = "root"
            #password = var.vsphere_vm_password
            host = "${var.main_ip}"
        }
    }
}