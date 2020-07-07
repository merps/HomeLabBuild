#!/usr/bin/env bash

sudo systemctl enable docker && sudo systemctl start docker
sudo systemctl enable kubelet && sudo systemctl start kubelet

sudo bash -c "echo "1" > /proc/sys/net/bridge/bridge-nf-call-iptables"
sudo bash -c "echo "1" > /proc/sys/net/bridge/bridge-nf-call-ip6tables"
 
sudo sysctl --system