variable "admin_image" {
  type        = "string"
  description = "Admin image slug"
  default     = "ubuntu-14-04-x64"
}

variable "admin_user" {
  type        = "string"
  description = "Admin user name"
  default     = "root"
}

variable "node_image" {
  type        = "string"
  description = "Image name"
  default     = "ubuntu-14-04-x64"
}

variable "node_user" {
  type        = "string"
  description = "Node user name"
  default     = "core"
}

variable "instances" {
  type        = "string"
  description = "Number of droplets to deploy"
  default     = "1"
}

variable "prefix" {
  type        = "string"
  description = "Basename of droplets"
  default     = "whateveryoulike"
}

variable "do_region" {
  # for this project you will want a region with volumes available
  type        = "string"
  description = "DigitalOcean droplet region"
  default     = "sfo2"
}

variable "size" {
  type        = "string"
  description = "Droplet RAM"
  default     = "512MB"
}

variable "ssh_id" {
  # change this
  type        = "string"
  description = "SSH public key ID - MD5 hash works: `ssh-keygen -l -E md5 -f ~/.ssh/id_rsa`"
  default     = "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
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

variable "s3bash_url" {
  type        = "string"
  description = "URL for bashrc stored on S3"
  default     = ""
}
