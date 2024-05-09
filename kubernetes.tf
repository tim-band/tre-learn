terraform {
    required_providers {
        kubernetes = { source = "hashicorp/kubernetes" }
    }
}

locals {
    app_name = "ScalableTreLearn"
    pod_name = "scalable-tre-learn"
    app_image = "timband/tre-learn:latest"
    app_port = 8080
    service_name = "tre-learn"
}

variable "host" { type = string }
variable "client_certificate" { type = string }
variable "client_key" { type = string }
variable "cluster_ca_certificate" { type = string }

provider "kubernetes" {
    host = var.host
    client_certificate = base64decode(var.client_certificate)
    client_key = base64decode(var.client_key)
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}

resource "kubernetes_deployment" "app" {
    metadata {
        name = local.pod_name
        labels = {
            App = local.app_name
        }
    }
    spec {
        replicas = 2
        selector {
            match_labels = {
                App = local.app_name
            }
        }
        template {
            metadata {
                labels = {
                    App = local.app_name
                }
            }
            spec {
                container {
                    image = local.app_image
                    name = "example"
                    port { container_port = local.app_port }
                    resources {
                        limits = {
                            cpu = "0.5"
                            memory = "512Mi"
                        }
                        requests = {
                            cpu = "250m"
                            memory = "50Mi"
                        }
                    }
                }
            }
        }
    }
}

resource "kubernetes_service" "app" {
    metadata { name = local.service_name }
    spec {
        selector = {
            App = kubernetes_deployment.app.spec.0.template.0.metadata[0].labels.App
        }
        port {
            node_port = 30201
            port = 80
            target_port = local.app_port
        }
        type = "NodePort"
    }
}
