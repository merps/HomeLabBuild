#! /bin/bash
sudo apt-get install -y docker.io
sudo systemctl enable docker
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo add-apt-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni

#MASTER INSTALL
sudo kubeadm init --config=kubeadm-config.yaml
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Get Kubectl CONFIG for export to local machine
cat $HOME/.kube/config
export KUBECONFIG=/mnt/c/Users/lucia/Documents/git_working/terraform_k3s_lab/proxmox-tf/prod/kubeconfig

#--- Network Install ---------------------------------------------------------------------------------------
#Cilium Install
kubectl create -f cilium.yaml
#Verify pods start up correctly
#kubectl -n kube-system get pods --watch


#--- Worker Node Install ---------------------------------------------------------------------------------------
#Install Worker Nodes
sudo kubeadm join 192.168.1.140:6443 --token m5tfd1.48ca3j74b7wv2ht4 --discovery-token-ca-cert-hash sha256:fad842c01a621d27fb7a02932c641260cb069a67afab656f85eff23dffc72caf


#--- Load Balancer Install ---------------------------------------------------------------------------------------
#Install LB - Using Metallb
kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/metallb/metallb-namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/metallb/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/metallb/metallbconfigmap.yaml


#--- Dashboard Install ---------------------------------------------------------------------------------------
#Install Dashboard
kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/dashboard/dashboard.yaml
#Create Admin Access
kubectl create -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/dashboard/dashboard.admin-user.yml -f dashboard.admin-user-role.yml
#Get Token for Access
kubectl -n kubernetes-dashboard describe secret admin-user-token | grep ^token
kubectl -n kubernetes-dashboard get services

#--- Storage Longhorn ---------------------------------------------------------------------------------------
kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/longhorn/001-longhorn.yaml
kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/longhorn/002-storageclass.yaml
kubectl -n longhorn-system get services

#--- Portainer Install ---------------------------------------------------------------------------------------
#Portainer Install
kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/portainer/portainer.yaml
#NodePort Install Below
#kubectl apply -f portainer-nodeport.yaml
### ---- Check LB IP and Port allocated  ---------------------------------------------------
kubectl -n portainer get services


#--- Hubble Install ---------------------------------------------------------------------------------------
#Hubble Install
kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/hubble/hubble.yaml
kubectl -n kube-system get services

#HELM Install
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo add influxdata https://helm.influxdata.com/

# K8s Infra monitoring stack --------------------------------------------------------------------------
# ---- Prometheus -----------
#kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/prometheus-grafana/prometheus/001-namespace.yaml
#kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/prometheus-grafana/prometheus/002-promdeploy.yaml
#kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/prometheus-grafana/prometheus/003-promconfig.yaml
#kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/prometheus-grafana/prometheus/004-nodeexport.yaml
#kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/prometheus-grafana/prometheus/005-statemetrics.yaml
kubectl create namespace monitoring
helm install prometheus stable/prometheus --namespace monitoring --set alertmanager.persistentVolume.storageClass="longhorn" --set server.persistentVolume.storageClass="longhorn"
#
#
# ---- Grafana -----------
#kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/f5k8slab/master/k8s/prometheus-grafana/grafana/001-grafana.yaml
Create grafana.yaml
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
    - name: Prometheus
      type: prometheus
      url: http://prometheus-server.monitoring.svc.cluster.local
      access: proxy
      isDefault: true
helm install grafana stable/grafana --namespace monitoring --set persistence.storageClassName="longhorn" --set persistence.enabled=true --set adminPassword='Mongo!123' --values grafana.yml --set service.type=LoadBalancer
### ---- Check LB IP and Port allocated  ---------------------------------------------------
kubectl -n monitoring get services

# --- InfluxDB ------
helm install influx influxdata/influxdb --namespace monitoring --set persistence.enabled=true,persistence.size=20Gi --set persistence.storageClass=longhorn

# ---- Speedtest--------
helm install speedtest billimek/speedtest -n monitoring
kubectl logs -f --namespace monitoring $(kubectl get pods --namespace monitoring -l app=speedtest -o jsonpath='{ .items[0].metadata.name }')

# EFK monitoring stack --------------------------------------------------------------------------
kubectl apply -f efk-logging/elastic.yaml
kubectl apply -f efk-logging/kibana.yaml
kubectl apply -f efk-logging/fluentd.yaml



