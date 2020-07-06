#===============================================================================
# Proxmox Leader Creation
#===============================================================================

resource "proxmox_vm_qemu" "k8sleader" {

  name = "K8s-leader-0"
  desc = "terraform-created vm"
  target_node = var.target_node

  clone = "ubuntu-ci"

  cores = var.cores
  sockets = 1
  memory = var.memory

  disk {
    id = 0
    type = "scsi"
    storage = var.storage_pool
    size = var.storage_size
  }

  network {
    id = 0
    model = "virtio"
    bridge = var.bridge
  }

  ssh_user = var.ssh_user

  os_type = "cloud-init"
  ipconfig0 = "ip=192.168.1.140/24,gw=192.168.1.1"

  sshkeys = var.ssh_key

# Configure Kubernetes #
    provisioner "file" {
        source      = "configure_phase1.sh"
        destination = "/tmp/configure_phase1.sh"
        connection {
            type     = "ssh"
            user     = "root"
            ##password = var.vsphere_vm_password
            host    = "192.168.1.140"
        }
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/configure_phase1.sh",
            "/tmp/configure_phase1.sh",
        ]
        connection {
            type     = "ssh"
            user     = "root"
            #password = var.vsphere_vm_password
            host    = "192.168.1.140"
        }
    }
    provisioner "remote-exec" {
        inline = [
            "apt-get install -y kubelet kubeadm kubectl kubernetes-cni"   
        ]
      
        connection {
            type     = "ssh"
            user     = "root"
            #password = var.vsphere_vm_password
            host    = "192.168.1.140"
        }
    }

    provisioner "file" {
        source      = "configure_phase2.sh"
        destination = "/tmp/configure_phase2.sh"

        connection {
            type     = "ssh"
            user     = "root"
            #password = var.vsphere_vm_password
            host    = "192.168.1.140"
        }
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/configure_phase2.sh",
            "/tmp/configure_phase2.sh",
        ]
        connection {
            type     = "ssh"
            user     = "root"
            #password = var.vsphere_vm_password
            host    = "192.168.1.140"
        }
    }
    provisioner "remote-exec" {
        inline = [
            "kubeadm init --pod-network-cidr=${var.proxmox_k8pod_network} --apiserver-advertise-address=192.168.1.140"
        ]
      
        connection {
            type     = "ssh"
            user     = "root"
            #password = var.vsphere_vm_password
            host    = "192.168.1.140"
        }
    }
    provisioner "file" {
        source      = "configure_phase3.sh"
        destination = "/tmp/configure_phase3.sh"

        connection {
            type     = "ssh"
            user     = "root"
            #password = var.vsphere_vm_password
            host    = "192.168.1.140"
        }
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/configure_phase3.sh",
            "/tmp/configure_phase3.sh",
        ]
        connection {
            type     = "ssh"
            user     = "root"
            #password = var.vsphere_vm_password
            host    = "192.168.1.140"
        }
    }

}

data "external" "kubeadm_join" {
    program = ["./kubeadm-token.sh"]

    query = {
        host = "192.168.1.140"
        key = var.ssh_key
    }

    depends_on = [
        proxmox_vm_qemu.k8sleader
    ]
}