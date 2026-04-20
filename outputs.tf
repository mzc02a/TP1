output "nginx_container_id" {
  description = "ID du conteneur nginx"
  value       = docker_container.nginx.id
}