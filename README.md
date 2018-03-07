# Tinker with Kubernetes

### Purpose

This code provisions a small cluster of droplets (VMs) on DigitalOcean.  After applying this code with Terraform you will be left with 1 master node and 3 worker nodes running Ubuntu 16.04 LTS.  Master node will have `kubeadm`, `kubectl`, and `kubelet` as well as kubectl bash completion activated.  Worker nodes will have `kubeadm` and `kubelet`.

### Requirements

* [Terraform][]

* [DigitalOcean][] account

* [ssh-agent][]

### Pre-Funk

1. Create a terraform variable file and specify the id/fingerprint of the ssh public key that you have on DigitalOcean.  You can also override any of the settings defined in the `variables.tf` file:

`$ vim terraform.tfvars`
```
ssh_id = "DigitalOcean SSH key ID or md5 fingerprint"
node_qty =  "count of worker nodes (default 3)"
region = "region (default sfo2)"
```

2. Export your DigitalOcean token as an environment variable:
```
$ export DIGITALOCEAN_TOKEN="your-long-token-string-here"
```

3. Initialize ssh-agent and add the SSH key that corresponds to the one you specified above:
```
$ eval $(ssh-agent)
$ ssh-add /path/to/your/id_rsa
```

### Instructions

2. Initialize
```
terraform init
```

3. Plan
```
terraform plan -out plan
```

4. Deploy
```
terraform apply plan
```

5. When the deployment is complete you should be able to SSH into the node IPs listed in Terraform's output as user `k8s`:
```
user@home:~$ ssh k8s@123.45.67.89 
k8s@helmsman:~$ 
```

* * *

To-do:

* Integrate Vault

[digitalocean]:                 https://cloud.digitalocean.com
[terraform]:                    https://www.terraform.io/downloads.html
[volume availability]:          https://www.digitalocean.com/community/tutorials/how-to-use-block-storage-on-digitalocean
[ssh-agent]:                    https://linux.die.net/man/1/ssh-agent
