#!/usr/bin/env bash

sudo systemctl enable --now kubelet
sudo systemctl enable docker && systemctl start docker

sudo bash -c "echo "1" > /proc/sys/net/ipv4/ip_forward"
sudo bash -c "echo "1" > /proc/sys/net/bridge/bridge-nf-call-iptables"

sudo sysctl --system