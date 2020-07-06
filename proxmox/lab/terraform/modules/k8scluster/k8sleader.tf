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


    provisioner "remote-exec" {
        inline = [
            "kubeadm init --pod-network-cidr=10.30.0.0/16 --apiserver-advertise-address=192.168.1.140"
        ]
      
        connection {
            type     = "ssh"
            user     = "root"
            password = "default"
            host    = "192.168.1.140"
        }
    }
    provisioner "remote-exec" {
        inline = [
            "mkdir -p $HOME/.kube",
            "cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
            "chown $(id -u):$(id -g) $HOME/.kube/config",
            "kubectl taint nodes --all node-role.kubernetes.io/master-",
            "kubectl create -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/cilium/cilium-custom.yaml",
            "kubectl get pods --all-namespaces",
            "kubectl get nodes -o wide"
        ]
      
        connection {
            type     = "ssh"
            user     = "root"
            password = "default"
            host    = "192.168.1.140"
        }
    }

}

data "external" "kubeadm_join" {
    program = ["./modules/k8scluster/kubeadm-token.sh"]

    query = {
        host = "192.168.1.140"
        key = var.sshkeys
    }

    depends_on = [
        proxmox_vm_qemu.k8sleader
    ]
}