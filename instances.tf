resource "digitalocean_droplet" "helmsman" {
  image              = "${var.admin_image}"
  name               = "helmsman"
  region             = "${var.do_region}"
  size               = "${var.size}"
  backups            = "False"
  ipv6               = "False"
  private_networking = "True"
  ssh_keys           = ["${var.ssh_id}"]

  tags = [
    "${digitalocean_tag.k8s.id}",
    "${digitalocean_tag.master.id}",
  ]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "${var.admin_user}"
      private_key = "${file("~/.ssh/id_rsa")}"
    }

    inline = [
      "apt-get -y update",
      "apt-get -y upgrade",
      "apt-get -y install docker.io",
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -",
      "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list",
      "apt-get -y update",
      "apt-get -y install kubeadm=${var.kube_version}-00 kubelet=${var.kube_version}-00 kubectl=${var.kube_version}-00",
      "wget wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml",
      "rm .bashrc",
      "wget ${var.s3bash_url}",
      "echo 'source <(kubectl completion bash)' | sudo tee -a .bashrc",
    ]
  }
}

resource "digitalocean_droplet" "oarsmen" {
  image              = "${var.node_image}"
  count              = "${var.instances}"
  name               = "${var.prefix}-${count.index+1}"
  region             = "${var.do_region}"
  size               = "${var.size}"
  backups            = "False"
  ipv6               = "False"
  private_networking = "True"
  ssh_keys           = ["${var.ssh_id}"]
  tags = [
    "${digitalocean_tag.k8s.id}",
    "${digitalocean_tag.worker.id}",
  ]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "${var.node_user}"
      private_key = "${file("~/.ssh/id_rsa")}"
    }

    inline = [
      "sudo mkdir -p /opt/cni/bin",
      "curl -L 'https://github.com/containernetworking/plugins/releases/download/v${var.cni_version}/cni-plugins-amd64-v${var.cni_version}.tgz' | sudo tar -C /opt/cni/bin -xz",
      "sudo mkdir -p /opt/bin",
      "curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/${var.kube_version}/bin/linux/amd64/kubeadm | sudo tee /opt/bin/kubeadm",
      "curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/${var.kube_version}/bin/linux/amd64/kubelet | sudo tee /opt/bin/kubelet",
      "curl -sSL 'https://raw.githubusercontent.com/kubernetes/kubernetes/v${var.kube_version}/build/debs/kubelet.service' | sed 's:/usr/bin:/opt/bin:g' | sudo tee /etc/systemd/system/kubelet.service",
      "sudo mkdir -p /etc/systemd/system/kubelet.service.d",
      "curl -sSL 'https://raw.githubusercontent.com/kubernetes/kubernetes/v${var.kube_version}/build/debs/10-kubeadm.conf' | sed 's:/usr/bin:/opt/bin:g' | sudo tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf",
      "sudo systemctl enable kubelet && sudo systemctl start kubelet",
      "sudo rm .bashrc",
      "wget ${var.s3bash_url}",
    ]
  }
}

output "helmsman" {
  value = "${digitalocean_droplet.helmsman.ipv4_address}"
}

output "oarsmen" {
  value = "${join(",\n", digitalocean_droplet.oarsmen.*.ipv4_address)}"
}
