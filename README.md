# Terraform on K3D learning

## Terraform

Terraform is a provisioning tool for getting VMs or containers into a
particluar state.

## K3D

`k3d` is a way of running `k3s` in Docker. It seems the servers and
agents still run on `containerd` (like `dockerd` but different?) but
the load balancer and Rancher things (for controlling the number of
agents and servers) are in docker containers.

`k3s` is a lightweight, compatible version of Kubernetes. This makes
`k3d` a lightweight version of `kind`, I think.

## Terraform configuration

`kubernetes.tf` started as just the code from
[the Terraform on Kubernetes tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider).

It requires a Kubernetes cluster to deploy to. Run `./create.sh` to
create this cluster (it will delete an old one if it exists). This
will create the file `terraform.tfvars` which is required by variable
interpolations in the `kubernetes.tf` configuration.

You can kill the cluster with `./kill.sh` and `ssh` into the first pod
with `ssh-pod.sh`. The docker containers running after creating the
cluster are two Ranchers and one load balancer; the pods themselves
run under `containerd`.

Terraform the cluster with `terraform apply`.

Once it is finished you will be able to see the nginx servers exposed
through the [ingress URL](http://localhost:33302).
