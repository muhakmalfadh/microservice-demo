provider "aws" {
  region = "ap-southeast-3"
}

data "aws_security_group" "master_node_sg" {
  id = "sg-0485d28f271f97bf6"
  name = "Master-Node-SG"
}

data "aws_security_group" "worker_node_sg" {
  id = "sg-05b07c6a85d18c6c3"
  name = "Worker-Node-SG"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "master_node" {
  count         = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  key_name      = "TLab"
  security_groups = [data.aws_security_group.master_node_sg.name]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  connection {
    host = self.public_ip
    type = "ssh"
    user = "ubuntu"
    private_key = file("../TLab.pem")
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [ 
      "echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/k8s.conf > /dev/null",
      "sudo sysctl --system",
      "sysctl net.ipv4.ip_forward",
      "sudo apt-get update",
      "sudo apt-get install ca-certificates curl -y",
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
      "sudo chmod a+r /etc/apt/keyrings/docker.asc",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo sed -i 's/\"//g' /etc/apt/sources.list.d/docker.list",
      "sudo apt-get update",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y",
      "containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1",
      "sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml",
      "sudo systemctl restart containerd",
      "sudo systemctl enable containerd",
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gpg",
      "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get update",
      "sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni",
      "sudo apt-mark hold kubelet kubeadm kubectl",
      "sudo systemctl enable --now kubelet",
      "swapoff -a",
      "sudo echo 'overlay' | sudo tee /etc/modules-load.d/containerd.conf > /dev/null",
      "sudo echo 'br_netfilter' | sudo tee -a /etc/modules-load.d/containerd.conf > /dev/null",
      "sudo modprobe overlay",
      "sudo modprobe br_netfilter",
      "sudo echo 'net.bridge.bridge-nf-call-ip6tables = 1' | sudo tee /etc/sysctl.d/kubernetes.conf > /dev/null",
      "sudo echo 'net.bridge.bridge-nf-call-iptables = 1' | sudo tee -a /etc/sysctl.d/kubernetes.conf > /dev/null",
      "sudo echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/kubernetes.conf > /dev/null",
      "sudo sysctl --system"
     ]
  }

  tags = {
    Name = "Master-Node"
  }
}

resource "aws_instance" "worker_node" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  key_name      = "TLab"
  security_groups = [data.aws_security_group.worker_node_sg.name]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  connection {
    host = self.public_ip
    type = "ssh"
    user = "ubuntu"
    private_key = file("../TLab.pem")
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [ 
      "echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/k8s.conf > /dev/null",
      "sudo sysctl --system",
      "sysctl net.ipv4.ip_forward",
      "sudo apt-get update",
      "sudo apt-get install ca-certificates curl -y",
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
      "sudo chmod a+r /etc/apt/keyrings/docker.asc",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo sed -i 's/\"//g' /etc/apt/sources.list.d/docker.list",
      "sudo apt-get update",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y",
      "containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1",
      "sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml",
      "sudo systemctl restart containerd",
      "sudo systemctl enable containerd",
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gpg",
      "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get update",
      "sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni",
      "sudo apt-mark hold kubelet kubeadm kubectl",
      "sudo systemctl enable --now kubelet",
      "swapoff -a",
      "sudo echo 'overlay' | sudo tee /etc/modules-load.d/containerd.conf > /dev/null",
      "sudo echo 'br_netfilter' | sudo tee -a /etc/modules-load.d/containerd.conf > /dev/null",
      "sudo modprobe overlay",
      "sudo modprobe br_netfilter",
      "sudo echo 'net.bridge.bridge-nf-call-ip6tables = 1' | sudo tee /etc/sysctl.d/kubernetes.conf > /dev/null",
      "sudo echo 'net.bridge.bridge-nf-call-iptables = 1' | sudo tee -a /etc/sysctl.d/kubernetes.conf > /dev/null",
      "sudo echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/kubernetes.conf > /dev/null",
      "sudo sysctl --system"
     ]
  }

  tags = {
    Name = "Worker-Node-${count.index + 1}"
  }
}