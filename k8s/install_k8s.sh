#MASTER INSTALL
#sudo kubeadm init --config=kubeadm-config.yaml
#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Get Kubectl CONFIG for export to local machine
#cat $HOME/.kube/config
#export KUBECONFIG=/mnt/c/Users/lucia/Documents/git_working/terraform_k3s_lab/proxmox-tf/prod/kubeconfig

#--- Network Install ---------------------------------------------------------------------------------------
#Cilium Install
#kubectl create -f cilium.yaml
#Verify pods start up correctly
#kubectl -n kube-system get pods --watch

sudo apt-get install     apt-transport-https     ca-certificates     curl     gnupg-agent     software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
cat /etc/docker/daemon.json 
systemctl enable docker && sudo systemctl start docker
systemctl enable kubelet && sudo systemctl start kubelet
bash -c "echo "1" > /proc/sys/net/bridge/bridge-nf-call-iptables"
bash -c "echo "1" > /proc/sys/net/bridge/bridge-nf-call-ip6tables"
sysctl --system
sudo swapoff -a

#Docker Install - https://docs.docker.com/engine/install/debian/
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo docker run hello-world


#--- Worker Node Install ---------------------------------------------------------------------------------------
#Install Worker Nodes
#sudo kubeadm join 192.168.1.140:6443 --token m5tfd1.48ca3j74b7wv2ht4 --discovery-token-ca-cert-hash sha256:fad842c01a621d27fb7a02932c641260cb069a67afab656f85eff23dffc72caf

#HELM Install - https://helm.sh/docs/intro/install/
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

#--- Load Balancer Install ---------------------------------------------------------------------------------------
#Install LB - Using Metallb
kubectl --kubeconfig ~/.kube/config_minikube apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/metallb/metallb-namespace.yaml
kubectl --kubeconfig ~/.kube/config_minikube apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/metallb/metallb.yaml
# On first install only
kubectl --kubeconfig ~/.kube/config_minikube create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/metallb/metallbconfigmap.yaml


#HELM Repos to Add Install
helm repo add portainer http://portainer.github.io/portainer-k8s
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo add influxdata https://helm.influxdata.com/
helm repo add elastic https://helm.elastic.co
helm repo add billimek https://billimek.com/billimek-charts/

#--- Portainer Install ---------------------------------------------------------------------------------------
#Portainer Install
#kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/portainer/portainer.yaml
#NodePort Install Below
#kubectl apply -f portainer-nodeport.yaml
### ---- Check LB IP and Port allocated  ---------------------------------------------------
#kubectl -n portainer get services
kubectl create namespace portainer
helm --kubeconfig ~/.kube/config_minikube install portainer portainer/portainer-beta --namespace portainer --set service.type="LoadBalancer"

#--- Storage Longhorn ---------------------------------------------------------------------------------------
kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/longhorn/001-longhorn.yaml
kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/longhorn/002-storageclass.yaml
kubectl -n longhorn-system get services
#Uninstall
#kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/master/uninstall/uninstall.yaml


#--- Hubble Install ---------------------------------------------------------------------------------------
#Hubble Install
kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/hubble/hubble.yaml
kubectl -n kube-system get services

# K8s Infra monitoring stack --------------------------------------------------------------------------
# ---- Prometheus -----------
#kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/prometheus-grafana/prometheus/001-namespace.yaml
#kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/prometheus-grafana/prometheus/002-promdeploy.yaml
#kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/prometheus-grafana/prometheus/003-promconfig.yaml
#kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/prometheus-grafana/prometheus/004-nodeexport.yaml
#kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/prometheus-grafana/prometheus/005-statemetrics.yaml
kubectl create namespace monitoring
helm install prometheus stable/prometheus --namespace monitoring --set alertmanager.persistentVolume.storageClass="longhorn" --set server.persistentVolume.storageClass="longhorn"


# ---- Grafana -----------
#kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/prometheus-grafana/grafana/001-grafana.yaml
helm install grafana stable/grafana --namespace monitoring --set persistence.storageClassName="longhorn" --set persistence.enabled=true --set adminPassword='Mongo!123' --values https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/prometheus-grafana/grafana/grafana.yaml --set service.type=LoadBalancer
### ---- Check LB IP and Port allocated  ---------------------------------------------------
kubectl -n monitoring get services

# --- InfluxDB ------
helm install influx influxdata/influxdb --namespace monitoring --set persistence.enabled=true,persistence.size=10Gi --set persistence.storageClass="longhorn"

# ---- Speedtest--------
helm install speedtest billimek/speedtest -n monitoring --set config.influxdb.host="influx-influxdb.monitoring" --set config.delay="300" --set debug="true"
kubectl logs -f --namespace monitoring $(kubectl get pods --namespace monitoring -l app=speedtest -o jsonpath='{ .items[0].metadata.name }')

# EFK monitoring stack --------------------------------------------------------------------------
kubectl apply -f efk-logging/elastic.yaml
kubectl apply -f efk-logging/kibana.yaml
kubectl apply -f efk-logging/fluentd.yaml

# ELk Logging Stack -----------------------------------------------------------------------------
# ElasticSearch Install
kubectl create namespace elk-logging
helm install elasticsearch --version 7.8.0 elastic/elasticsearch -n elk-logging --set minimumMasterNodes="1" --set replicas="2" --values https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/efk-logging/elastic_values.yaml
# Logstash Install
helm install logstash elastic/logstash -n elk-logging --set replicas="2" --values https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/efk-logging/logstash_values.yaml
#Kibana
#helm install kibana elastic/kibana -n elk-logging --set replicas="2" --set elasticsearchHosts="http://elasticsearch.elk-logging:9200" --values https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/efk-logging/kibana_values.yaml
kubectl apply -f https://raw.githubusercontent.com/JLCode-tech/HomeLabBuild/master/k8s/efk-logging/kibana.yaml



