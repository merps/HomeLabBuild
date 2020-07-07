#===============================================================================
# Proxmox Node Creation
#===============================================================================

resource "null_resource" "previous2" {}

resource "time_sleep" "wait_2_mins2" {
  depends_on = [null_resource.previous]

  create_duration = "120s"
}


# Create the Proxmox Nodes #
resource "proxmox_vm_qemu" "k8snode1" {

  #count = length(192.168.1.141)

  #name = "${var.node_name}" + count.index
  name = "K8s-node-1"
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
  sshkeys = var.sshkeys

  os_type = "cloud-init"
  #ipconfig0 = "ip=${"${192.168.1.141}" + count.index}/24,gw=192.168.1.1"
  ipconfig0 = "ip=192.168.1.141/24,gw=${var.gateway}"

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get install open-iscsi -y",
            "sudo chmod 600 /home/debian/.ssh/authorized_keys",
            "sudo cp /home/debian/.ssh/authorized_keys /root/.ssh/authorized_keys"
        ]

        connection {
            type     = "ssh"
            user     = "debian"
            password = "default"
            host    = "192.168.1.141"
        }
    }

    #provisioner "remote-exec" {
    #    inline = [
    #        "${data.external.kubeadm_join.result.command}"
    #    ]
      
    #    connection {
    #        type     = "ssh"
    #        user     = "root"
    #        password = "default"
    #        host    = "192.168.1.141"
    #    }
    #}

}