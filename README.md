# Kubernetes Cluster using Virtual Box

This is a quick and basic setup for a single-master, duo worker node `Kubernetes` cluster using VirtualBox to virtualize the nodes. The setup uses vagrant to quickly pull VM images (`Ubuntu/Focal64`) and bootstraps the nodes, installing `docker`, `kubelet`, `kubectl`, `kubeadm` and the `Flannel CNI`. This is tested for K8s `1.24.0` and kubectl `1.24.0`.

## Requirements

- Windows (`amd64`) Host Machine
- `Vagrant`(>=`2.2.19`): To quickly provision and bootstrap the nodes
- `VirtualBox`(>=`6.1.30`): For virtualization of the nodes
- `Kubernetes` (>=`1.24.0`): Tested on this version
- \>= 2 CPUs and >= 2 GB RAM per node (configurable in `Vagrantfile`)
- Each node must have a unique **private IP** and **hostname** on the `VirtualBox` host network. (configurable in `Vagrantfile` under the key `config.vm.network` and `config.vm.provision` respectively)
- The K8s cluster uses the [Flannel](https://github.com/flannel-io/flannel) as a node networking solution.

> Take note of [Using Vagrant with Flannel](https://github.com/flannel-io/flannel/blob/master/Documentation/troubleshooting.md#vagrant), where the CNI might not work due to vagrant's multiple network iface. This is resolved by adding an additional arg for the flannel image in `kube-master/manifests/flannel-cni.yml`.

## Usage

1. Ensure that the `VirtualBox` UI is running.
2. Go to `./kube-master` and run `vagrant up`
3. Ensure that the `kube-master` node is properly setup by running `kubectl get nodes` and `kubectl get pods --all-namespaces`, all pods should show `1/1` and the master node should be `READY`.
4. Retrieve the following command using `sudo cat /kubeadm.log` in the `kube-master`'s directory. Ensure that `sudo` is present when running it on the worker node VMs (steps 5,7).

```bash
sudo kubeadm join <NODE_IP>:6443 --token <TOKEN> \
        --discovery-token-ca-cert-hash sha256:<HASH>
```

5. Go to `./kube-w1` and run `vagrant up`
6. Run the command from step `4`.
7. Go to `./kube-w2` and run `vagrant up`
8. Run the command from step `4`.
9. Go back to `kube-master` and run `kubectl get nodes`, all 3 nodes should show as `READY`

## Default credentials

The vagrant default credentials for the vm are `vagrant:vagrant`. This can be configured in the `Vagrantfile`. Refer to the Vagrant documentation.

## To use custom SSH Key for the VMs (Optional)

The script will look out for `./id_rsa.pub` in the root directory. If present, the SSH key will be uploaded to all of the nodes.

> The `id_rsa.pub` is git ignored and will need to be defined after cloning.

## Bootstrap Script Args

The kube installation script runs when the VM is **provisioned** and first started up and is called `bootstrap-kube-xx.sh`. The bash script takes in 2 positional arguments.

1. The hostname to set for the node
1. The kubernetes version to install ( `1.24.0` | `x.x.x` )
