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

Hosts file (Transition to DNS - future)

/etc/resolv.conf
search luciatech.co
nameserver 8.8.8.8
nameserver 8.8.4.4

/etc/hosts
192.168.0.250 mando.luciatech.co mando
192.168.0.248 yoda.luciatech.co yoda
192.168.0.152 kuiil.luciatech.co kuiil
192.168.0.153 cara.luciatech.co cara
192.168.0.154 remnant.luciatech.co remnant
192.168.0.155 razor.luciatech.co razor

### Create SSH Key for K8s and subsequent installs
ssh-keygen -t rsa
/root/.ssh/luciatech.co.kubernetes

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
### Copy Keys from mando
Copy SSH Key
scp root@mando:/root/.ssh/luciatech.co.kubernetes.pub /root/.ssh/luciatech.co.kubernetes.pub
scp root@mando:/root/.ssh/luciatech.co.kubernetes /root/.ssh/luciatech.co.kubernetes

## Install Ansible
```apt-get update
   apt-get upgrade
   apt install software-properties-common -y
   apt-add-repository --yes --update ppa:ansible/ansible
   apt install ansible -y
```
### Install Ansible Playbooks for Infrastructure from GIT
Script Copies from Github
apt-get install -y git
git clone https://github.com/JLCode-tech/Bootstrap-Kubernetes-with-QEMU.git

* Do not run playbooks until VM infrabuild below

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

### VM build + Kubernetes Infra via Ansible
Run the deployment: `ansible-playbook -i inventory.ini site.yml`
After deployment, a `~/.kube` directory will be created on CICD Host. You can use the `config` file within to interact with your cluster.

### CICD to Access WebUI
kubectl --kubeconfig config describe -n kube-system secret jarrodl-token | grep token: | awk '{print $2}'
kubectl --kubeconfig config proxy


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

    