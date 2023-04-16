# userdata

# Docker start
systemctl start docker 
systemctl enable docker 

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start Minikube
su - minikube
minikube start --vm-driver=none --extra-config=kubelet.cgroup-driver=systemd
