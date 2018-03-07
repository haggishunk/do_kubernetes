resource "digitalocean_droplet" "helmsman" {
  image              = "${var.admin_image}"
  name               = "helmsman"
  region             = "${var.region}"
  size               = "${var.admin_size}"
  backups            = false
  ipv6               = false
  private_networking = true
  monitoring         = false
  ssh_keys           = ["${var.ssh_id}"]

  tags = [
    "${digitalocean_tag.k8s.id}",
    "${digitalocean_tag.master.id}",
  ]

  connection {
    type = "ssh"
    user = "root"
  }

  # create admin acct
  provisioner "remote-exec" {
    inline = ["${data.template_file.newuser.rendered}"]
  }
}

resource "null_resource" "helmsman" {
  # connect with admin acct
  connection {
    type = "ssh"
    host = "${digitalocean_droplet.helmsman.ipv4_address}"
    user = "${var.user}"
  }

  # make bash pretty
  provisioner "file" {
    content     = "${data.template_file.bashrc.rendered}"
    destination = "/home/${var.user}/.bashrc"
  }

  # make terminal usable
  provisioner "file" {
    content     = "${data.template_file.inputrc.rendered}"
    destination = "/home/${var.user}/.inputrc"
  }

  # install docker
  provisioner "remote-exec" {
    inline = ["${data.template_file.docker.rendered}"]
  }

  # install kubeadm, kubectl, kubelet
  provisioner "remote-exec" {
    inline = ["${data.template_file.kubernetes.rendered}"]
  }
  
  # flannel config
  provisioner "file" {
    content = "${data.template_file.kube-flannel-yaml.rendered}"
    destination = "/home/${var.user}/kube-flannel.yml"
  }

  # start cluster with kubeadm
  provisioner "remote-exec" {
    inline = ["${data.template_file.kubernetes-start.rendered}"]
  }

  provisioner "local-exec" {
    command = "scp -3 -o StrictHostKeyChecking=no ${var.user}@${digitalocean_droplet.helmsman.ipv4_address}:*.pem ."
  }
}

resource "digitalocean_droplet" "oarsmen" {
  image              = "${var.node_image}"
  count              = "${var.node_qty}"
  name               = "${var.node_prefix}-${count.index+1}"
  region             = "${var.region}"
  size               = "${var.node_size}"
  backups            = false
  ipv6               = false
  private_networking = true
  monitoring         = false
  ssh_keys           = ["${var.ssh_id}"]

  tags = [
    "${digitalocean_tag.k8s.id}",
    "${digitalocean_tag.worker.id}",
  ]

  connection {
    type = "ssh"
    user = "root"
  }

  # create admin acct
  provisioner "remote-exec" {
    inline = ["${data.template_file.newuser.rendered}"]
  }
}

resource "null_resource" "oarsmen" {
  count = "${var.node_qty}"

  # connect with admin acct
  connection {
    type = "ssh"
    host = "${element(digitalocean_droplet.oarsmen.*.ipv4_address, count.index)}"
    user = "${var.user}"
  }

  # make bash pretty
  provisioner "file" {
    content     = "${data.template_file.bashrc.rendered}"
    destination = "/home/${var.user}/.bashrc"
  }

  # make terminal usable
  provisioner "file" {
    content     = "${data.template_file.inputrc.rendered}"
    destination = "/home/${var.user}/.inputrc"
  }

  # install docker
  provisioner "remote-exec" {
    inline = ["${data.template_file.docker.rendered}"]
  }

  # install kubeadm, kubectl, kubelet
  provisioner "remote-exec" {
    inline = ["${data.template_file.kubernetes.rendered}"]
  }
}

resource "null_resource" "oarsmen-join-up" {
  count = "${var.node_qty}"

  # connect with admin acct
  connection {
    type = "ssh"
    host = "${element(digitalocean_droplet.oarsmen.*.ipv4_address, count.index)}"
    user = "${var.user}"
  }

  # copy the token string to each worker
  provisioner "local-exec" {
    command = "scp -3 -o StrictHostKeyChecking=no ${var.user}@${digitalocean_droplet.helmsman.ipv4_address}:kube-join ${var.user}@${element(digitalocean_droplet.oarsmen.*.ipv4_address, count.index)}:kube-join"
  }

  # join the cluster with the token string
  provisioner "remote-exec" {
    inline = ["sudo sh kube-join"]
  }
}
 
output "helmsman-ip" { 
  value = "${digitalocean_droplet.helmsman.ipv4_address}"
}

output "helmsman-ssh" {
  value = "${var.user}@${digitalocean_droplet.helmsman.ipv4_address}"
}

output "oarsmen-ip" {
  value = "${digitalocean_droplet.oarsmen.*.ipv4_address}"
}
