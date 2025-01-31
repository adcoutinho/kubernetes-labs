#!/usr/bin/env bash

export KUBERNETES_VERSION="1.31.0"
export CLUSTER_NAME="kind-cluster"

# Upgrade packages
echo "[TASK 1] Upgrade all packages and Prerequisites"
sudo apt-get -qq update -y 
sudo apt-get -qq install -y apt-transport-https ca-certificates curl gnupg lsb-release bzip2 gcc make perl ssh docker.io

# Enable ssh password authentication
echo "[TASK 2] Enable ssh password authentication"
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
sudo echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
sudo systemctl reload sshd

# Set Root password
echo "[TASK 3] Set root password"
echo -e "adclab\nadclab" | sudo passwd root >/dev/null 2>&1

# Remove SWAP
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Set sysctl arguments
echo "[TASK 4] Set Sysctl arguments"
echo "fs.inotify.max_user_watches=655360" >> /etc/sysctl.conf
echo "fs.inotify.max_user_instances=1280" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-iptables=0" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-arptables=0" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables=0" >> /etc/sysctl.conf
sudo sysctl -p

# Set up user docker permission
echo "[TASK 5] Set up docker permission"
sudo groupadd docker
sudo adduser vagrant docker
sudo chown vagrant /var/run/docker.sock
sudo systemctl restart docker

# Install kind
echo "[TASK 6] Install kind"
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Install kubectl 
echo "[TASK 7] Install kubectl"
curl -LO https://dl.k8s.io/release/v$KUBERNETES_VERSION/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Cluster config
echo "[TASK 8] Create cluster config file"
cat >cluster-config.yaml<<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v$KUBERNETES_VERSION
- role: worker
  image: kindest/node:v$KUBERNETES_VERSION
EOF

# Create cluster
echo "[TASK 9] Create cluster"
kind create cluster --name $CLUSTER_NAME --config cluster-config.yaml --wait 2m
kind export kubeconfig --name kind-cluster

# Helm installation
echo "[TASK 10] Helm Install"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

echo "Setup Completed!!!"
