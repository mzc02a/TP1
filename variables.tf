variable "machines" {
  description = "Liste des machines virtuelles à déployer"

  type = list(object({
    name      = string
    vcpu      = number
    disk_size = number
    region    = string
  }))

  default = [
    {
      name      = "vm-app"
      vcpu      = 2
      disk_size = 20
      region    = "eu-west-1"
    },
    {
      name      = "vm-db"
      vcpu      = 4
      disk_size = 50
      region    = "us-east-1"
    }
  ]

  validation {
    condition = alltrue([
      for machine in var.machines :
      machine.vcpu >= 2 && machine.vcpu <= 64
    ])
    error_message = "Chaque machine doit avoir un nombre de vCPU entre 2 et 64."
  }

  validation {
    condition = alltrue([
      for machine in var.machines :
      machine.disk_size >= 20
    ])
    error_message = "Chaque machine doit avoir une taille de disque supérieure ou égale à 20 Go."
  }

  validation {
    condition = alltrue([
      for machine in var.machines :
      contains(["eu-west-1", "us-east-1", "ap-southeast-1"], machine.region)
    ])
    error_message = "La région doit être l'une des suivantes : eu-west-1, us-east-1, ap-southeast-1."
  }
}