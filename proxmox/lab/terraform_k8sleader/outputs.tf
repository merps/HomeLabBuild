
output "kubeadm_join" {
    value = "${data.external.kubeadm_join.result.command}"
}