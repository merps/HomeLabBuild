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

Allow Root SSH login
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

Add in Multiple Interfaces
 - eth1 Internal
 - eth2 Control

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

## Install Terraform
```apt-get update
   apt-get upgrade
   apt install software-properties-common -y
```



### CICD Pipeline Infra
- Drone Install



- Github Integration

# IaC Section Below

Objective of the Lab is to do as much as possible as Infrastructure as Code (IaC). This includes all VM hosts, K8s cluster, F5, and additional services.

## Ubuntu VM Hosts

### VM build + Kubernetes Infra via Terraform




### CICD to Access WebUI
kubectl --kubeconfig config describe -n kube-system secret jarrodl-token | grep token: | awk '{print $2}'
kubectl --kubeconfig config proxy


## VyOS Mgmt Router (Network Mgmt Interfaces)

git clone https://github.com/JLCode-tech/VyosHome
1. Run the deployment: `ansible-playbook -i inventory.ini vyossite.yml`

## Install F5
    - mgmt IP off VyOS





## Stacks to be installed (Kubernetes Prefered)

### K8s installs





- CIS K8s
- Monitoring
        Prometheus
        Grafana
- Logging
        Kafka - EFK

    