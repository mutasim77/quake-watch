variable "app_name" {
  type        = string
  description = "Application Name"
  default     = "name" # You application name
}

variable "project_id" {
  type        = string
  description = "The name of the project"
  default     = "id"  # You project id
}

variable "region" {
  type        = string
  description = "The default compute region"
  default     = "" # Region
}

variable "zone" {
  type        = string
  description = "The default compute zone"
  default     = "" # Zone
}

variable "credentials" {
  description = "key for credentials acess"
  default     = "./keys/keys.json" # GPC Credentials
}

variable "storage_class" {
  description = "Storage class type for bucket"
  default     = "STANDARD"
}

variable "bq_dataset" {
  description = "BigQuery Dataset that data will be written to"
  type        = string
  default     = ""  # Name of BQ dataset
} 

variable "docker_image" {
  type        = string
  description = "The docker image to deploy to Cloud Run."
  default     = "mageai/mageai:latest" # The name of image
}

variable "docker_image_tag" {
  type        = string
  description = "The docker image tag to deploy to Cloud Run."
  default     = "tag" # tag for image
}

variable "docker_image_name" {
  type        = string
  description = "The docker image name to deploy to Cloud Run."
  default     = "name" # name of image
}

variable "artifact_registry_path" {
  type        = string
  description = "The docker image tag to deploy to Cloud Run."
  default     = "" # Your Artifact Registry Path
}
