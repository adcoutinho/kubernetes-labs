#!/bin/bash

echo "[TASK 10] Pull required containers"
kubeadm config images pull >/dev/null

echo "[TASK 11] Initialize Kubernetes Cluster"
# without kube-proxy
kubeadm init --apiserver-advertise-address=master.adclab.com.br --pod-network-cidr=192.168.56.0/24 --skip-phases=addon/kube-proxy >> /root/kubeinit.log 2>/dev/null

echo "[TASK 12] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh
