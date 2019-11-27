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
    - manual build done
    - script VM build
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

    