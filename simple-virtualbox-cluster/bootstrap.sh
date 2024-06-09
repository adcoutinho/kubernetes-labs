#!/usr/bin/env bash

KUBERNETES_VERSION="1.28.10-1.1"
KUBERNETES_MAJOR_VERSION=`echo $KUBERNETES_VERSION | cut -b -4`
CONTAINERD_VERSION="1.7.2-0ubuntu2"

# disable swap for kubelet
sudo swapoff -a

# configs iptables
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system


# add kubernetes repo
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$KUBERNETES_MAJOR_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$$KUBERNETES_MAJOR_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# install kubernetes packages
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gpg
sudo apt install -y kubeadm=$KUBERNETES_VERSION kubelet=$KUBERNETES_VERSION kubectl=$KUBERNETES_VERSION
sudo apt-mark hold kubelet kubeadm kubectl

# setup containerd
sudo apt install containerd=$CONTAINERD_VERSION
 
