resource "digitalocean_tag" "k8s" {
  name = "k8s"
}
resource "digitalocean_tag" "master" {
  name = "master"
}
resource "digitalocean_tag" "worker" {
  name = "worker"
}
