variable "image_name" {
  description = "Nom de l'image Docker"
  type        = string
  default     = "nginx:latest"
}

variable "container_name" {
  description = "Nom du conteneur"
  type        = string
  default     = "nginx-terraform"
}

variable "external_port" {
  description = "Port externe"
  type        = number
  default     = 8080
}

variable "internal_port" {
  description = "Port interne"
  type        = number
  default     = 80
}

variable "server_names" {
  description = "Liste des noms des serveurs clients"
  type        = list(string)
  default     = ["app", "api", "db"]
}