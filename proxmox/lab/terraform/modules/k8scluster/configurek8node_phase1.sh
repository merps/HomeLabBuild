#!/usr/bin/env bash

sudo mount bpffs -t bpf /sys/fs/bpf

sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo su -
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
exit
sudo add-apt-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get update