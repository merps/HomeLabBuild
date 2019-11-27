# HomeLabBuild

# Proxmox Build
done (manual build at this stage)

## Initial Management Container (CICD)

### GoDaddy Dynamic DNS Script
   ```apt-get update
   apt-get install curl
   chmod 700 godaddyddns.sh 
   Test Script ./godaddyddns.sh:
   
   root@CICD:~# ./godaddyddns.sh 
   2019-11-27 01:15:55 - Current External IP is 121.213.211.149, GoDaddy DNS IP is 121.213.211.149
   ```

  Install script into CRONTAB
  ```crontab -l | { cat; echo "*/15 * * * * /root/godaddyddns.sh"; } | crontab -
  ```


## Install Ansible
```apt-get update
   apt-get upgrade
   apt install software-properties-common
   apt-add-repository --yes --update ppa:ansible/ansible
   apt install ansible
```


## Install Docker CE for CICD Pipeline


## Install Drone CI


## Install Portainer


# IaC Section Below


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
- CICD Pipeline Infra
        Drone for CI
        Github
- Monitoring
        Prometheus
        Grafana
- Logging
        Kafka - EFK

    