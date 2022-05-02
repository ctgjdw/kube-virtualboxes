# Kubernetes Cluster using Virtual Box

This is a quick and basic setup for a single-master, duo worker node `Kubernetes` cluster using VirtualBox to virtualize the nodes. The setup uses vagrant to quickly pull VM images (`Ubuntu/Focal64`) and bootstraps the nodes, installing `docker`, `kubelet`, `kubectl` and `kubeadm`. This is tested for K8s `v1.23.6` and kubectl `v1.23.6`.

## Requirements

- Windows (`amd64`) Host Machine
- `Vagrant`(>=`2.2.19`): To quickly provision and bootstrap the nodes
- `VirtualBox`(>=`6.1.30`): For virtualization of the nodes
- \>= 2 CPUs and >= 2 GB RAM per node (configurable in `Vagrantfile`)
- Each node must have a seperate static IP on the `VirtualBox` host network. (configurable in `Vagrantfile`, `config.vm.network`)

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
