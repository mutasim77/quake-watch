variable "app_name" {
  type        = string
  description = "Application Name"
  default     = "earthquakes"
}

variable "project_id" {
  type        = string
  description = "The name of the project"
  default     = "copper-axiom-326903"
}

variable "region" {
  type        = string
  description = "The default compute region"
  default     = "us-east1"
}

variable "zone" {
  type        = string
  description = "The default compute zone"
  default     = "us-east1-c"
}

variable "credentials" {
  description = "key for credentials acess"
  default     = "./keys/keys.json"
}

variable "storage_class" {
  description = "Storage class type for bucket"
  default     = "STANDARD"
}

variable "bq_dataset" {
  description = "BigQuery Dataset that data will be written to"
  type        = string
  default     = "earthquake_dataset"
}

variable "docker_image" {
  type        = string
  description = "The docker image to deploy to Cloud Run."
  default     = "mageai/mageai:latest"
}

variable "docker_image_tag" {
  type        = string
  description = "The docker image tag to deploy to Cloud Run."
  default     = "mage-image"
}

variable "docker_image_name" {
  type        = string
  description = "The docker image tag to deploy to Cloud Run."
  default     = "mageai"
}

variable "artifact_registry_path" {
  type        = string
  description = "The docker image tag to deploy to Cloud Run."
  default     = "us-east1-docker.pkg.dev/copper-axiom-326903/quakewatch-repository"
}
