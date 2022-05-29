#!/bin/bash
whoami
HOSTNAME=$1
KUBE_VER=$2
printf "Installing K8=$KUBE_VER-00 on $HOSTNAME\n"

if [ -f "/home/vagrant/.ssh/id_rsa.pub" ]
then
  cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
  printf "Added id_rsa.pub to server!\n"
fi

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install ca-certificates software-properties-common apt-transport-https curl gnupg lsb-release -y

sudo hostnamectl set-hostname $HOSTNAME
sudo swapoff -a && sudo sed -i 's/\/swap/#\/swap/g' /etc/fstab

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list >/dev/null

sudo apt-get update
sudo apt-get install -y docker.io
sudo apt-mark hold docker.io

sudo tee /etc/docker/daemon.json >/dev/null <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo apt-get install -y kubelet=$KUBE_VER-00 kubeadm=$KUBE_VER-00 kubectl=$KUBE_VER-00
sudo apt-mark hold kubelet kubeadm kubectl

echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
