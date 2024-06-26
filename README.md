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
cluster are one Rancher and one load balancer; the pods themselves
run under `containerd`. You can create multiple Ranchers if you like
but I don't know what effect that has or why you'd want it.

Terraform the cluster with `terraform apply`.

Once it is finished you will be able to see the servers exposed
through the [ingress URL](http://localhost:33302).

## Dockerfile

The Dockerfile is used to build a docker image which is pushed to
Docker Hub as `timband/tre-learn`. This image is used in the
Terraform deployment.

## Debugging

In `kubernetes.tf` set `local.debug` to `true`, then `terraform apply`.
You need to wait for the build to complete in the container.
Once the server is up you can connect to the pod:

```sh
./debug-tunnel.sh
```

and in another terminal:

```sh
dlv connect --init source/tre/learn/delve-init.txt localhost:32100
```

A suitable VSCode launch configuration looks like:

```json
{
    "name": "Connect to 32100",
    "type": "go",
    "request": "attach",
    "mode": "remote",
    "cwd": "${workspaceFolder}",
    "port": 32100,
    "host": "127.0.0.1",
    "showLog": true,
    "trace": "log",
    "logOutput": "rpc",
    "apiVersion": 2
},
```

You might have to re-run `debug-tunnel.sh` and relaunch the debugger a
few times to get this to work.
