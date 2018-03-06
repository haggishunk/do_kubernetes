data "template_file" "newuser" {
  template = "${file("${path.root}/terraform-template-files/newuser-template.sh")}"

  vars {
    user = "${var.user}"
  }
}

data "template_file" "docker" {
  template = "${file("${path.root}/terraform-template-files/docker-install-apt.sh")}"

  vars {
    user           = "${var.user}"
    docker_version = "${var.docker_version}"
  }
}

data "template_file" "kubernetes" {
  template = "${file("${path.root}/terraform-template-files/kubernetes.sh")}"

  vars {
    user         = "${var.user}"
    kube_version = "${var.kube_version}"
  }
}

data "template_file" "kube-flannel-yaml" {
  template = "${file("${path.root}/terraform-template-files/kube-flannel.yml")}"

  vars {
    network_cidr = "${var.overlay_network_cidr}"
  }
}

data "template_file" "kubernetes-start" {
  template = "${file("${path.root}/terraform-template-files/kubernetes-start.sh")}"

  vars {
    network_cidr = "${var.overlay_network_cidr}"
  }
}

# data "template_file" "kubernetes-join" {
#   template = "${file("${path.root}/terraform-template-files/kubernetes-join.sh")}"

#   vars {
#     network_cidr = "${var.overlay_network_cidr}"
#   }
# }

data "template_file" "inputrc" {
  template = "${file("${path.root}/terraform-template-files/inputrc")}"
}

data "template_file" "bashrc" {
  template = "${file("${path.root}/terraform-template-files/bashrc")}"

  vars {
    col1 = 39
    col2 = 202
  }
}
