data "template_file" "newuser" {
  template = "${file("${path.root}/terraform-template-files/newuser-template.sh")}"

  vars {
    user      = "${var.user}"
  }
}

data "template_file" "kubernetes" {
  template = "${file("${path.root}/terraform-template-files/kubernetes.sh")}"

  vars {
    kube_version = "${var.kube_version}"
  }
}

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
