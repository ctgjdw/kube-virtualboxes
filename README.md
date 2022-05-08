# Kubernetes Cluster using Virtual Box

This is a quick and basic setup for a single-master, duo worker node `Kubernetes` cluster using VirtualBox to virtualize the nodes. The setup uses vagrant to quickly pull VM images (`Ubuntu/Focal64`) and bootstraps the nodes, installing `docker`, `kubelet`, `kubectl` and `kubeadm`. This is tested for K8s `v1.23.6` and kubectl `v1.23.6`.

## Requirements

- Windows (`amd64`) Host Machine
- `Vagrant`(>=`2.2.19`): To quickly provision and bootstrap the nodes
- `VirtualBox`(>=`6.1.30`): For virtualization of the nodes
- \>= 2 CPUs and >= 2 GB RAM per node (configurable in `Vagrantfile`)
- Each node must have a seperate static IP on the `VirtualBox` host network. (configurable in `Vagrantfile`, `config.vm.network`)
- The K8s cluster uses the [Flannel](https://github.com/flannel-io/flannel) as a node networking solution.

## Usage

1. Ensure that the `VirtualBox` UI is running.
1. Go to `./kube-master` and run `vagrant up`
2. Ensure that the `kube-master` node is properly setup by running `kubectl get nodes` and `kubectl get pods --all-namespaces`, all pods should show `1/1` and the master node should be `READY`.
3. Retrieve the following command using `sudo cat /kubeadm.log` in the `kube-master`'s directory.  

```bash
        sudo kubeadm join <NODE_IP>:6443 --token <TOKEN> \
                --discovery-token-ca-cert-hash sha256:<HASH>
```

4. Go to `./kube-w1` and run `vagrant up`
5. Run the command from step 3.
6. Go to `./kube-w2` and run `vagrant up`
7. Run the command from step 3.
8. Go back to `kube-master` and run `kubectl get nodes`, all 3 nodes should show as `READY`
