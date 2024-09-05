#!/bin/bash

echo "[TASK 10] Pull required containers"
kubeadm config images pull >/dev/null

echo "[TASK 11] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=master.adclab.com.br --pod-network-cidr=192.168.56.0/24 >> /root/kubeinit.log 2>/dev/null

echo "[TASK 12] Deploy Calico network" ****
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml >/dev/null
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml >/dev/null

echo "[TASK 13] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh
