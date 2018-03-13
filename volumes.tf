resource "digitalocean_volume" "seabag" {
  region = "${var.region}"
  count  = "${var.storage_qty}"
  name   = "seabag-${count.index}"
  size   = "${var.size_vol}"
}
