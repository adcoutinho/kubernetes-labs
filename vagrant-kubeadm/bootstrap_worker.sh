#!/bin/bash

echo "[TASK 10] Join node to Kubernetes Cluster"
export DEBIAN_FRONTEND=noninteractive
sudo apt install -qq -y sshpass >/dev/null
sshpass -p "adclab" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no master.adclab.com.br:/joincluster.sh /joincluster.sh >/dev/null 2>&1
bash /joincluster.sh >/dev/null
