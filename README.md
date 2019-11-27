# HomeLabBuild

# Proxmox Build
complete (manual build at this stage)

## Initial Management Container (CICD)

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

  
## Install Ansible
```apt-get update
   apt-get upgrade
   apt install software-properties-common
   apt-add-repository --yes --update ppa:ansible/ansible
   apt install ansible
```
### Install Ansible Playbooks for Infrastructure
Script Copies from Github


## Install Docker


## Install Portainer


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

    