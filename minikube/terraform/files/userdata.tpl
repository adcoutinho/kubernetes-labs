#!/bin/bash
# userdata

# Docker start
systemctl start docker 
systemctl enable docker 

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube

# Start Minikube
minikube start --extra-config=kubelet.cgroup-driver=systemd

minikube kubectl proxy --port=8080
