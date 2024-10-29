#!/usr/bin/env bash

export KUBERNETES_VERSION="1.29.8-1.1"
export KUBERNETES_MAJOR_VERSION=`echo $KUBERNETES_VERSION | cut -b -4`
export CONTAINERD_VERSION="1.7.20-1"
export DEBIAN_FRONTEND=noninteractive

# Upgrade packages
echo "[TASK 1] Upgrade all packages and Prerequisites"
sudo apt-get -qq update && sudo apt-get -qq upgrade -y 
sudo apt-get -qq install -y apt-transport-https ca-certificates curl gnupg lsb-release bzip2 gcc make perl ssh

# Enable ssh password authentication
echo "[TASK 2] Enable ssh password authentication"
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
sudo systemctl reload sshd

# Set Root password
echo "[TASK 3] Set root password"
echo -e "adclab\nadclab" | sudo passwd root >/dev/null 2>&1

# Disable swap for kubelet
echo "[TASK 4] Disable swap"
sudo sed -i '/swap/d' /etc/fstab
sudo swapoff -a

# Add Kernel settings
echo "[TASK 5] Add Kernel settings"
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

# Install Containerd
echo "[TASK 6] Install Containerd"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -qq update >/dev/null
sudo apt-get -qq install -y containerd.io=$CONTAINERD_VERSION >/dev/null
sudo containerd config default > /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd >/dev/null

# Add kubernetes repo
echo "[TASK 7] Add kubernetes repo"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$KUBERNETES_MAJOR_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$KUBERNETES_MAJOR_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null
sudo chmod a+r /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Install kubernetes packages
echo "[TASK 8] Install kubernetes packages"
sudo apt update -qq >/dev/null
sudo apt install -qq -y kubeadm=$KUBERNETES_VERSION kubelet=$KUBERNETES_VERSION kubectl=$KUBERNETES_VERSION
sudo apt-mark hold kubelet kubeadm kubectl

# Config hosts
echo "[TASK 9] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.56.10   master.adclab.com.br     master
192.168.56.11   worker1.adclab.com.br    worker1
192.168.56.12   worker2.adclab.com.br    worker2
EOF
