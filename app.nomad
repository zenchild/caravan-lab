variable "dist-port" {
  type    = number
  default = 4370
}

variable "service-name" {
  type    = string
  default = "caravan-lab"
}

variable "consul-service-address" {
  type    = string
  default = "service.devl.consul"
}

variable "docker-image" {
  type    = string
}

variable "secret-key-base" {
  type    = string
  default = "XxCXBx3xBUuWCNIzmFMavQntSSYt1QQGyAWMpZ3hqB/Bx4YKk+gRtVqhtZWlVinX"
}

job "caravan-lab" {
  datacenters = ["*"]

  group "app" {
    count = 3

    network {
      mode     = "bridge"
      hostname = "node-${NOMAD_HOST_PORT_dist}"
      port "dist" {
        to = var.dist-port
      }

      dns {
        servers = ["${attr.unique.network.ip-address}"]
      }
    }

    service {
      name         = var.service-name
      port         = "dist"
      provider     = "consul"
      address      = "node-${NOMAD_ALLOC_INDEX}.${var.service-name}.${var.consul-service-address}"
      address_mode = "auto"

      tags = [
        "node-${NOMAD_ALLOC_INDEX}"
      ]
    }

    task "app" {
      driver = "docker"

      config {
        image      = var.docker-image
        force_pull = true
        ports      = ["dist"]
      }

      env {
        SECRET_KEY_BASE      = var.secret-key-base
        ERL_DIST_PORT        = var.dist-port
        ELIXIR_ERL_OPTIONS   = "-start_epmd false -epmd_module Elixir.Caravan.Epmd.Client"
        DNS_CLUSTER_QUERY    = "${var.service-name}.${var.consul-service-address}"
        RELEASE_DISTRIBUTION = "name"
        RELEASE_NODE         = "node-${NOMAD_ALLOC_INDEX}@${var.service-name}.${var.consul-service-address}"
      }
    }
  }
}
