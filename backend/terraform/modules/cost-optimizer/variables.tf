variable "instance_tags_to_keep" {
  description = "Liste des tags des instances à démarrer/arrêter"
  type        = list(string)
  default     = ["Rcvo-Server", "Rcvo-Backend-lb", "Rcvo-Backend-env", "Rcvo-Backend-prod"]
}

variable "private_subnet_id" {
  description = "ID du subnet privé pour la NAT instance"
  type        = string
}
