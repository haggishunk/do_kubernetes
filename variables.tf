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

variable "admin_size" {
  type        = "string"
  description = "Droplet RAM"
  default     = "1GB"
}

variable "node_image" {
  type        = "string"
  description = "Image name"
  default     = "ubuntu-14-04-x64"
}

variable "node_user" {
  type        = "string"
  description = "Node user name"
  default     = "root"
}

variable "node_instances" {
  type        = "string"
  description = "Number of droplets to deploy"
  default     = "1"
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

variable "node_image_core" {
  type        = "string"
  description = "Image name"
  default     = "coreos-stable"
}

variable "node_user_core" {
  type        = "string"
  description = "Node user name"
  default     = "core"
}

variable "node_instances_core" {
  type        = "string"
  description = "Number of droplets to deploy"
  default     = "1"
}

variable "node_prefix_core" {
  type        = "string"
  description = "Basename of droplets"
  default     = "anotherthingyoulike"
}

variable "node_size_core" {
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
