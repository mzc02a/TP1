terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "docker" {
  host = "tcp://localhost:2375"
}

# Réseau Docker dédié
resource "docker_network" "nginx_network" {
  name = "nginx-network"
}

# Image Nginx
resource "docker_image" "nginx" {
  name         = var.image_name
  keep_locally = true
}

# Image curl
resource "docker_image" "curl" {
  name         = "appropriate/curl"
  keep_locally = true
}

# Conteneur Nginx
resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  networks_advanced {
    name    = docker_network.nginx_network.name
    aliases = ["nginx"]
  }
}

# Test automatique depuis la machine locale
resource "null_resource" "test_nginx" {
  depends_on = [docker_container.nginx]

  provisioner "local-exec" {
    command = "curl http://localhost:${var.external_port} | findstr Welcome"
  }
}

# Conteneur client
resource "docker_container" "client" {
  count = var.client_count

  name  = "client-${count.index}"
  image = docker_image.curl.image_id

  depends_on = [docker_container.nginx]

  command = [
    "sh",
    "-c",
    "curl http://nginx:80 && sleep 30"
  ]

  networks_advanced {
    name = docker_network.nginx_network.name
  }
}