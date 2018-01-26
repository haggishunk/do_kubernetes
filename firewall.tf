resource "digitalocean_firewall" "ssh" {
  name = "kube-ssh-22"

  droplet_ids = [
    "${digitalocean_droplet.helmsman.id}",
    "${digitalocean_droplet.oarsmen.*.id}",
  ]


  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0"]
    },
  ]
}

resource "digitalocean_firewall" "update" {
  name = "kube-update"

  droplet_ids = [
    "${digitalocean_droplet.helmsman.id}",
    "${digitalocean_droplet.oarsmen.*.id}",
  ]


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
    {
      protocol   = "icmp"
      port_range = "1-65535"

      destination_addresses = ["0.0.0.0/0"]
    },
  ]
}

# resource "digitalocean_firewall" "inter" {
#   name = "kube-cross-node-traffic"


#   droplet_ids = [
#     # "${digitalocean_droplet.helmsman.id}",
#     # "${digitalocean_droplet.oarsmen.*.id}",
#   ]


#   inbound_rule = [
#     {
#       protocol   = "tcp"
#       port_range = "1-65535"


#       source_addresses = [
#         "${digitalocean_droplet.helmsman.ipv4_address}",
#         "${digitalocean_droplet.oarsmen.*.ipv4_address}",
#       ]
#     },
#   ]


#   outbound_rule = [
#     {
#       protocol   = "tcp"
#       port_range = "1-65535"


#       destination_addresses = [
#         "${digitalocean_droplet.helmsman.ipv4_address}",
#         "${digitalocean_droplet.oarsmen.*.ipv4_address}",
#       ]
#     },
#   ]
# }

