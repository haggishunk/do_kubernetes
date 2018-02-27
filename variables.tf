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
  default     = "1GB"
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
  default     = "1GB"
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

variable "ssh_pri_file" {
  type = "string"
  description = "file path of ssh private file"
  default = "~/.ssh/id_rsa"
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
