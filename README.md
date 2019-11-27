# HomeLabBuild

# Proxmox Build
complete (manual build at this stage)

   Git and NTP installs
   
   ```apt-get install ntp -y
      apt-get install git -y
      git clone https://github.com/JLCode-tech/HomeLabBuild.git
   ```

NTP
echo "Australia/Sydney" | sudo tee /etc/timezone

### GoDaddy Dynamic DNS Script
   ```apt-get update
   apt-get install curl
   chmod 700 godaddyddns.sh
   #Install script into CRONTAB
   crontab -l | { cat; echo "*/15 * * * * /root/godaddyddns.sh"; } | crontab -
   
   Test Script ./godaddyddns.sh:
   root@CICD:~# ./godaddyddns.sh 
   2019-11-27 01:15:55 - Current External IP is 121.213.211.149, GoDaddy DNS IP is 121.213.211.149
   ```

## Initial Management Container (CICD)

### CICD Base Install
Create LXC Container 
 - edit file /etc/pve/lxc/1##.conf which allows docker to run inside an LXC container
 ```unprivileged: 0 #Allows privileged Docker
    lxc.apparmor.profile: unconfined
    lxc.cgroup.devices.allow: a
    lxc.cap.drop:
```

## Install Ansible
```apt-get update
   apt-get upgrade
   apt install software-properties-common -y
   apt-add-repository --yes --update ppa:ansible/ansible
   apt install ansible -y
```
### Install Ansible Playbooks for Infrastructure
Script Copies from Github


## Install Docker


```apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce
```

## Install Portainer
```mkdir /root/portainer
   mkdir /root/portainer/data
   docker run -d -p 9000:9000 -v /root/portainer/data:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
```

## Install Drone CI

### CICD Pipeline Infra
- Drone Install
- Github Integration

# IaC Section Below

Objective of the Lab is to do as much as possible as Infrastructure as Code (IaC). This includes all VM hosts, K8s cluster, F5, and additional services.

## Ubuntu VM Hosts
 - To Do
    ## manual build done

ready system for k8s

```cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
swapoff -a
```
### Install Docker
apt-get install -y apt-transport-https curl
apt-get install -y docker.io
systemctl enable --now docker

### Install K8s
Add Sources for install
```curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
systemctl enable kubelet  
systemctl start kubelet

docker info | grep -i cgroup
Cgroup Driver: cgroupfs
```

Update config file:
/etc/systemd/system/kubelet.service.d/10-kubeadm.conf

```[Service]
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"
```

kubeadm init --service-cidr 10.96.0.0/12 --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address 192.168.0.152


Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.0.152:6443 --token t6zu9r.q3sqhi4d0us5984w \
    --discovery-token-ca-cert-hash sha256:3c0f1c47faefd0a036af1a199c87087fad83b3cdbaccd9778e647108153e8069

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


kubectl config set-credentials ubuntu --username=jarrodl --password=default
kubectl config set-cluster home --server=http://192.168.0.152:8080
kubectl config set-context home-context --cluster=home --user=ubuntu
kubectl config use-context home-context
kubectl config set contexts.home-context.namespace the-right-prefix
kubectl config view


## script VM build (To Do)
        - packages
        - networks

## Install Kubernetes Infra


## VyOS Mgmt Router (Network Mgmt Interfaces)
    -   script vm for proxmox

## Install F5
    - mgmt IP off VyOS
    - External IP (192.168.0.155)
        Firewall ingress
        LB ingress for K8s


## Stacks to be installed (Kubernetes Prefered)

- Monitoring
        Prometheus
        Grafana
- Logging
        Kafka - EFK

    