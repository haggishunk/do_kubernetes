resource "digitalocean_firewall" "ssh" {
  name = "kube-ssh-22"

  tags = ["${digitalocean_tag.k8s.name}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0"]
    },
  ]
}

resource "digitalocean_firewall" "web" {
  name = "kube-web-80"

  tags = ["${digitalocean_tag.k8s.name}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["0.0.0.0/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["0.0.0.0/0"]
    },
  ]
}

resource "digitalocean_firewall" "outbound" {
  name = "kube-update"

  tags = ["${digitalocean_tag.k8s.name}"]

  outbound_rule = [
    {
      protocol   = "tcp"
      port_range = "1-65535"

      destination_addresses = ["0.0.0.0/0"]
    },
    {
      protocol   = "udp"
      port_range = "1-65535"

      destination_addresses = ["0.0.0.0/0"]
    },
  ]
}

resource "digitalocean_firewall" "master" {
  name = "kube-master"

  tags = ["${digitalocean_tag.master.name}"]

  inbound_rule = [
    {
      protocol   = "tcp"
      port_range = "6443"

      source_tags = ["${digitalocean_tag.k8s.name}"]
    },
    {
      protocol = "tcp"
      port_range = "6443"

      source_addresses = ["${var.admin_source_cidr}"]
    },
    {
      protocol   = "tcp"
      port_range = "2379-2380"

      source_tags = ["${digitalocean_tag.k8s.name}"]
    },
    {
      protocol   = "tcp"
      port_range = "10250-10255"

      source_tags = ["${digitalocean_tag.k8s.name}"]
    },
  ]
}

resource "digitalocean_firewall" "worker" {
  name = "kube-worker"

  tags = ["${digitalocean_tag.worker.name}"]

  inbound_rule = [
    {
      protocol   = "tcp"
      port_range = "10250"

      source_tags = ["${digitalocean_tag.k8s.name}"]
    },
    {
      protocol   = "tcp"
      port_range = "10255"

      source_tags = ["${digitalocean_tag.k8s.name}"]
    },
    {
      protocol   = "tcp"
      port_range = "30000-32767"

      source_addresses = ["0.0.0.0/0"]
    },
  ]
}

resource "digitalocean_firewall" "rook" {
  name = "rook"

  tags = ["${digitalocean_tag.k8s.name}"]

  inbound_rule = [
    {
      protocol   = "tcp"
      port_range = "8124"

      source_tags = ["${digitalocean_tag.k8s.name}"]
    },
  ]
}

