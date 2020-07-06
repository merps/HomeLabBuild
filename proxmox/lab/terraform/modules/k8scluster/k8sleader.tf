#===============================================================================
# Proxmox Leader Creation
#===============================================================================

resource "proxmox_vm_qemu" "k8sleader" {

  name = "K8s-leader-0"
  desc = "terraform-created vm"
  target_node = var.target_node

  clone = "debian-10-template"

  cores = var.cores
  sockets = 1
  memory = var.memory

  disk {
    id = 0
    type = "virtio"
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

  sshkeys = var.sshkeys
  #sshkeys = <<EOF
  #    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUMACmb30ibzLXL0YmzObJZEzyjfOVNTwVo9wVCwkvQtigKbPlmc+WPY9O1+VDTAIdLua/bIESYtQmWoVy48/Zz+nBgF9+RsqM1P6FXW/s5y3P0fbsoqCbLKP9uM3b2lLKnwzfzDvWBvjjLsMPW6AG6uStj087t+l5kQMo1fvc/lEclddYrL/SIoebZrslflA0ZHdXr4RTgKIX4V6zcnBN/Yc4xwd8FtEyovn7ibZz4ZuKHi6Ff9M/hfD6z1HHbqgLWQacv4uTf4rw5Wsu8dtYO9+wZbFpCHc7q+eNi9rO2O0/QsJ0KGMmNn4BegLevZwju9x8Q/J4UGhBlKAgOCGN ubuntu@pve00"
#EOF


# Configure Kubernetes #
    provisioner "file" {
        source      = ".//modules/k8scluster/configurek8sleader_phase1.sh"
        destination = "/tmp/configurek8sleader_phase1.sh"
        connection {
            type     = "ssh"
            user     = "debian"
            password = "default"
            host    = "192.168.1.140"
        }
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/configurek8sleader_phase1.sh",
            "/tmp/configurek8sleader_phase1.sh",
        ]
        connection {
            type     = "ssh"
            user     = "debian"
            password = "default"
            host    = "192.168.1.140"
        }
    }
    provisioner "remote-exec" {
        inline = [
            "sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni"   
        ]
      
        connection {
            type     = "ssh"
            user     = "debian"
            password = "default"
            host    = "192.168.1.140"
        }
    }

    provisioner "file" {
        source      = ".//modules/k8scluster/configurek8sleader_phase2.sh"
        destination = "/tmp/configurek8sleader_phase2.sh"

        connection {
            type     = "ssh"
            user     = "debian"
            password = "default"
            host    = "192.168.1.140"
        }
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/configurek8sleader_phase2.sh",
            "/tmp/configurek8sleader_phase2.sh",
        ]
        connection {
            type     = "ssh"
            user     = "debian"
            password = "default"
            host    = "192.168.1.140"
        }
    }
    provisioner "remote-exec" {
        inline = [
            "sudo kubeadm init --pod-network-cidr=10.30.0.0/16"
        ]
      
        connection {
            type     = "ssh"
            user     = "debian"
            password = "default"
            host    = "192.168.1.140"
        }
    }
    provisioner "file" {
        source      = ".//modules/k8scluster/configurek8sleader_phase3.sh"
        destination = "/tmp/configurek8sleader_phase3.sh"

        connection {
            type     = "ssh"
            user     = "debian"
            password = "default"
            host    = "192.168.1.140"
        }
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/configurek8sleader_phase3.sh",
            "/tmp/configurek8sleader_phase3.sh",
        ]
        connection {
            type     = "ssh"
            user     = "debian"
            password = "default"
            host    = "192.168.1.140"
        }
    }

}

data "external" "kubeadm_join" {
    program = ["./kubeadm-token.sh"]

    query = {
        host = "192.168.1.140"
        key = var.sshkeys
    }

    depends_on = [
        proxmox_vm_qemu.k8sleader
    ]
}