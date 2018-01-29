# Tinker with Kubernetes

### Purpose

This code provisions a small cluster of droplets (VMs) on DigitalOcean.  After applying this code with Terraform you will be left with 1 master node and 3 worker nodes running Ubuntu 16.04 LTS.  Master node will have `kubeadm`, `kubectl`, and `kubelet` as well as kubectl bash completion activated.  Worker nodes will have `kubeadm` and `kubelet`.

### Requirements

* [Terraform][]

* [DigitalOcean][] account

### Instructions

1. Make changes to terraform config files

* `terraform.tfvars`
  * `ssh_id:` change to your DigitalOcean SSH key md5 fingerprint
  * `node_instances:` change to desired number of worker nodes _(optional)_
  * `region:` change to desired DigitalOcean instance region.  Consider selecting a region with [volume availability][] if you would like to experiment with attached storage. _(optional)_

* `provider.tf`
  * `token:` change file path to location of your DigitalOcean token string

* `instances.tf`
  * `connection - private_key:` ensure private key file matches fingerprint specified with `ssh_id` above

2. Initialize
```
terraform init
```

3. Plan
```
terraform plan
```

4. Deploy and respond with 'yes' at the prompt.
```
terraform apply
```

5. When the deployment is complete you should be able to SSH into the node IPs listed in Terraform's output
```
user@home:~$ ssh root@123.45.67.89 
root@helmsman:~$ 
```

* * *

To-do:

* Play with CoreOS workers

[digitalocean]:                 https://cloud.digitalocean.com
[terraform]:                    https://www.terraform.io/downloads.html
[volume availability]:          https://www.digitalocean.com/community/tutorials/how-to-use-block-storage-on-digitalocean
