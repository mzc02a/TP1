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

# Provider Docker (Windows)
provider "docker" {
  host = "tcp://localhost:2375"
}

# Image Docker
resource "docker_image" "nginx" {
  name         = var.image_name
  keep_locally = true
}

# Conteneur Docker
resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }
}

# Test automatique Nginx
resource "null_resource" "test_nginx" {
  depends_on = [docker_container.nginx]

  provisioner "local-exec" {
    command = "curl http://localhost:${var.external_port} | findstr Welcome"
  }
}