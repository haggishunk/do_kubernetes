variable "user" {
  type        = "string"
  description = "Admin user name"
  default     = "k8s"
}

variable "admin_image" {
  type        = "string"
  description = "Admin image slug"
  default     = "ubuntu-16-04-x64"
}

variable "admin_size" {
  type        = "string"
  description = "Droplet RAM"
  default     = "4GB"
}

variable "node_image" {
  type        = "string"
  description = "Image name"
  default     = "ubuntu-16-04-x64"
}

variable "node_qty" {
  type        = "string"
  description = "Number of droplets to deploy"
  default     = "3"
}

variable "node_prefix" {
  type        = "string"
  description = "Basename of droplets"
  default     = "whateveryoulike"
}

variable "node_size" {
  type        = "string"
  description = "Droplet RAM"
  default     = "4GB"
}

variable "region" {
  type        = "string"
  description = "DigitalOcean droplet region"
  default     = "sfo2"
}

variable "ssh_id" {
  # change this
  type        = "string"
  description = "SSH public key ID - MD5 hash works: `ssh-keygen -l -E md5 -f ~/.ssh/id_rsa`"
  default     = "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
}

variable "docker_version" {
  type        = "string"
  description = "Version of docker"
  default     = "17.03.2"
}

variable "kube_version" {
  type        = "string"
  description = "Version of kubeadm, kubelet, kubectl"
  default     = "1.9.2"
}

variable "cni_version" {
  type        = "string"
  description = "Version of CNI"
  default     = "0.6.0"
}

variable "overlay_network_cidr" {
  type        = "string"
  description = "Network CIDR to use for Kubernetes cluster overlay"
  default     = "10.244.0.0/16"
}

variable "admin_source_cidr" {
  type        = "string"
  description = "Where you are permitted to access the k8s api from"
  default     = "0.0.0.0/0"
}
