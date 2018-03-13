resource "digitalocean_droplet" "helmsman" {
  image              = "${var.image}"
  name               = "${var.admin_prefix}"
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
    content     = "${data.template_file.kube-flannel-yaml.rendered}"
    destination = "/home/${var.user}/kube-flannel.yml"
  }

  # start cluster with kubeadm
  provisioner "remote-exec" {
    inline = ["${data.template_file.kubernetes-start.rendered}"]
  }

  # delete existing known_hosts entry for this droplet
  # copy certs to local machine
  provisioner "local-exec" {
    command = <<EOF
sed -i '/${digitalocean_droplet.helmsman.ipv4_address}/d' ~/.ssh/known_hosts ;
scp -3 -o StrictHostKeyChecking=no ${var.user}@${digitalocean_droplet.helmsman.ipv4_address}:*.pem .
EOF
  }
}

resource "digitalocean_droplet" "oarsmen" {
  image              = "${var.image}"
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

resource "digitalocean_droplet" "holds" {
  image              = "${var.image}"
  count              = "${var.storage_qty}"
  name               = "${var.storage_prefix}-${count.index+1}"
  region             = "${var.region}"
  size               = "${var.storage_size}"
  backups            = false
  ipv6               = false
  private_networking = true
  monitoring         = false
  volume_ids         = ["${element(digitalocean_volume.seabag.*.id, count.index)}"]
  ssh_keys           = ["${var.ssh_id}"]

  tags = [
    "${digitalocean_tag.k8s.id}",
    "${digitalocean_tag.worker.id}",
    "${digitalocean_tag.psv.id}",
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
  count = "${var.node_qty + var.storage_qty}"

  # re-configure if new droplet
  triggers = {
    oarsmen = "${digitalocean_droplet.oarsmen.*.id}",
    holds   = "${digitalocean_droplet.holds.*.id}",
  }

  # connect with admin acct
  connection {
    type = "ssh"
    host = "${element(concat(digitalocean_droplet.oarsmen.*.ipv4_address, digitalocean_droplet.holds.*.ipv4_address), count.index)}"
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
  count = "${var.node_qty + var.storage_qty}"

  # final join should happen after token is generated
  # and after worker config
  depends_on = [
    "null_resource.helmsman",
    "null_resource.oarsmen",
  ]

  # rejoin if new droplet
  triggers = {
    oarsmen = "${digitalocean_droplet.oarsmen.*.id}",
    holds   = "${digitalocean_droplet.holds.*.id}",
  }

  # connect with admin acct
  connection {
    type = "ssh"
    host = "${element(concat(digitalocean_droplet.oarsmen.*.ipv4_address, digitalocean_droplet.holds.*.ipv4_address), count.index)}"
    user = "${var.user}"
  }

  # delete existin known_hosts entry for subject droplet(s)
  # copy the token string to each worker
  provisioner "local-exec" {
    command = <<EOF
sed -i '/${element(concat(digitalocean_droplet.helmsman.*.ipv4_address, digitalocean_droplet.holds.*.ipv4_address), count.index)}/d' ~/.ssh/known_hosts ;
scp -3 -o StrictHostKeyChecking=no \
${var.user}@${digitalocean_droplet.helmsman.ipv4_address}:kube-join \
${var.user}@${element(concat(digitalocean_droplet.oarsmen.*.ipv4_address, digitalocean_droplet.holds.*.ipv4_address), count.index)}:kube-join
EOF
  }

  # join the cluster with the token string
  provisioner "remote-exec" {
    inline = ["sudo sh kube-join"]
  }
}

output "helmsman-ssh" {
  value = "${var.user}@${digitalocean_droplet.helmsman.ipv4_address}"
}

output "helmsman-ip" {
  value = "${digitalocean_droplet.helmsman.ipv4_address}"
}

output "oarsmen-ip" {
  value = "${digitalocean_droplet.oarsmen.*.ipv4_address}"
}

output "holds-ip" {
  value = "${digitalocean_droplet.holds.*.ipv4_address}"
}
