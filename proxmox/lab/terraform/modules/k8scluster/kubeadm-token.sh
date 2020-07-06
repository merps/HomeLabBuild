#!/usr/bin/env bash

set -e

# Extract "host" and "key_file" argument from the input into HOST shell variable
eval "$(jq -r '@sh "HOST=\(.host) KEY=\(.key)"')"

# Fetch the join command
CMD=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/id_rsa.pub \
    root@192.168.1.140 kubeadm token create --print-join-command)

# Produce a JSON object containing the join command
jq -n --arg command "$CMD" '{"command":$command}'