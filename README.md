#HomeLabBuild

Home Lab Build Steps

Proxmox Build

Ubuntu VM Hosts
    To Do
        - manual build done
        - script VM build
            - packages
            - networks

Install Kubernetes Infra


VyOS Mgmt Router (Network Mgmt Interfaces)
    -   script vm for proxmox

Install F5
    - mgmt IP off VyOS
    - External IP (192.168.0.155)
        Firewall ingress
        LB ingress for K8s


Stacks to be installed (Kubernetes Prefered)
    - CICD Pipeline Infra
        Drone for CI
        Github
    - Monitoring
        Prometheus
        Grafana
    - Logging
        Kafka - EFK

    