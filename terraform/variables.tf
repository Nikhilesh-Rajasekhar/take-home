variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "db_user_container_image" {
  description = "Docker image for DB user container"
  type        = string
  default     = "dockeruser/dbusercontainer:latest"
}

variable "shifts_container_image" {
  description = "Docker image for shifts container"
  type        = string
  default     = "dockeruser/shiftscontainer:latest"
}

variable "db_user_replica_count" {
  description = "Number of replicas for DB user container deployment"
  type        = number
  default     = 2
}

variable "shifts_replica_count" {
  description = "Number of replicas for shifts container deployment"
  type        = number
  default     = 2
}

variable "cpu_threshold_percentage" {
  description = "CPU threshold percentage for horizontal pod autoscaling"
  type        = number
  default     = 70
}

variable "namespace" {
  description = "Namespace to deploy the Kubernetes resources"
  type        = string
  default     = "default"
}

variable "db_user_dbname" {
  description = "Database name for DB user container"
  type        = string
  default     = "user_db"
}

variable "shifts_dbname" {
  description = "Database name for shifts container"
  type        = string
  default     = "shifts_db"
}
