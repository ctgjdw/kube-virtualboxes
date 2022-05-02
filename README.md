# Kubernetes Cluster using Virtual Box

[[__TOC__]]

This is a quick and basic setup for a single-master, duo worker node `Kubernetes` cluster using VirtualBox to virtualize the nodes. The setup uses vagrant to quickly pull VM images (`Ubuntu/Focal64`) and bootstraps the nodes, installing `docker`, `kubelet`, `kubectl` and `kubeadm`.

## Requirements

- Windows (amd64) Host Machine
- `Vagrant`: To quickly provision and bootstrap the nodes
- `VirtualBox`: For virtualization of the nodes

## Usage

1. Go to `./kube-master` and run `vagrant up`
1. Ensure that the `kube-master` node is properly setup by running `kubectl get nodes` and `kubectl get pods --all-namespaces`, all pods should show `1/1` and the master node should be `READY`.
1. Retrieve the following command from `~/kubeadm.log` in the `kube-master`'s directory.  

    Example:

        ```bash
        kubeadm join <NODE_IP>:6443 --token <TOKEN> \
                --discovery-token-ca-cert-hash sha256:<HASH>
        ```

1. Go to `./kube-w1` and run `vagrant up`
1. Run the command from step 3.
1. Go to `./kube-w2` and run `vagrant up`
1. Run the command from step 3.
1. Go back to `kube-master` and run `kubectl get nodes`, all 3 nodes should show as `READY`
