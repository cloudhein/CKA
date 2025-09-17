## Setup Configuration

### Download cri-dockerd 

`This adapter provides a shim for Docker Engine that lets you control Docker via the Kubernetes Container Runtime Interface.`

```bash
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.9/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb
```

### Install required dependencies

```bash
sudo apt update
sudo apt install -y libseccomp2
```

## Solution Setup

### Install the Debian package ~/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb

```bash
sudo dpkg -i ~/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb
```

### Enable and start the cri-docker service

```bash
sudo systemctl enable --now cri-docker.service
```

```bash
systemctl status cri-docker.service
```

### Configure required system parameters:

```bash
sudo bash -c 'cat <<EOF > /etc/sysctl.d/cka-kubernetes-sysctl.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv6.conf.all.forwarding = 1
net.ipv4.ip_forward = 1
net.netfilter.nf_conntrack_max = 131072
EOF'
```

#### Load configuration of specific parameters (option 1)
```bash
sysctl -p /etc/sysctl.d/cka-kubernetes-sysctl.conf
```

#### Load the system again (option 2)
```bash
sudo sysctl --system
```