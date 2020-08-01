#===============================================================================
# Proxmox Leader Creation
#===============================================================================

resource "proxmox_vm_qemu" "k8sleader" {

  name = "K8s-leader-0"
  desc = "terraform-created vm"
  target_node = var.target_node

  clone = var.template_name

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
  ipconfig0 = "ip=${var.leader_ip}/24,gw=${var.gateway}"

  sshkeys = var.sshkeys

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get install open-iscsi -y",
            "sudo swapoff -a",
            "kubeadm init --pod-network-cidr=10.30.0.0/16 --apiserver-advertise-address=192.168.1.140 --control-plane-endpoint=192.168.1.140 --token-ttl=0"
        ]
      
        connection {
            type     = "ssh"
            user     = "root"
            password = "default"
            host    = var.leader_ip
        }
    }
    provisioner "remote-exec" {
        inline = [
            "mkdir -p $HOME/.kube",
            "cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
            "chown $(id -u):$(id -g) $HOME/.kube/config",
            #"kubectl taint nodes --all node-role.kubernetes.io/master-",
            "kubectl create -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/cilium/cilium-custom.yaml",
            #"kubectl create -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/calico/calicooperator.yaml",
            #"kubectl create -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/calico/calico.yaml",
            "kubectl get pods --all-namespaces",
            "kubectl get nodes -o wide"
        ]
      
        connection {
            type     = "ssh"
            user     = "root"
            password = "default"
            host    = var.leader_ip
        }
    }
    #provisioner "remote-exec" {
    #    inline = [
    #        "sudo chmod 600 /home/debian/.ssh/authorized_keys",
    #        "sudo cp /home/debian/.ssh/authorized_keys /root/.ssh/authorized_keys"
    #    ]

    #    connection {
    #        type     = "ssh"
    #        user     = "debian"
    #        password = "default"
    #        host    = var.leader_ip
    #    }
    #}

}

data "external" "kubeadm_join" {
    program = ["./kubeadm-token.sh"]

    #query = {
    #    host = "${var.leader_ip}"
    #    key = var.sshkeys
    #}

    depends_on = [
        proxmox_vm_qemu.k8sleader
    ]
}