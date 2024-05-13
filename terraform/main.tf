terraform {
  required_version = ">= 0.14"

  required_providers {
    google = ">= 3.3"

    google-beta = ">= 3.3"
  }
}

provider "google" {
  credentials = var.credentials
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

provider "google-beta" {
  credentials = var.credentials
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

#=======Google Cloud Storage=======
resource "google_storage_bucket" "data_bucket" {
  name     = "quakewatch"
  location = var.region

  storage_class               = var.storage_class
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 120 // days
    }
  }
  force_destroy = true
}

#=======Big Query=======
resource "google_bigquery_dataset" "data_earthquake" {
  dataset_id = var.bq_dataset
  project    = var.project_id
  location   = var.region
}

resource "google_bigquery_table" "default" {
  dataset_id = google_bigquery_dataset.data_earthquake.dataset_id
  table_id   = "earthquake_data"

  time_partitioning {
    type  = "DAY"
    field = "date"
  }

  clustering = ["continent", "week"]

  schema = file("./earthquakes_schema.json")

  deletion_protection = false
}


#=======Create the Cloud Run service=======

# Step 1: Build your Docker image (assuming you have a Dockerfile in your directory)
resource "null_resource" "build_docker_image" {
  provisioner "local-exec" {
    command = "docker build -t ${var.docker_image_tag} ."
  }
}

# Step 2: Tag the Docker image with the Artifact Registry path
resource "null_resource" "tag_docker_image" {
  provisioner "local-exec" {
    command = "docker tag ${var.docker_image_tag} ${var.artifact_registry_path}/${var.docker_image_name}"
  }
  depends_on = [null_resource.build_docker_image]
}

# Step 3: Push the Docker image to Artifact Registry
resource "null_resource" "push_docker_image" {
  provisioner "local-exec" {
    command = "docker push ${var.artifact_registry_path}/${var.docker_image_name}"
  }
  depends_on = [null_resource.tag_docker_image]
}

# Step 4: Deploy the Cloud Run service using the Docker image from Artifact Registry
resource "google_cloud_run_service" "run_service" {
  name     = "${var.app_name}-mageai"
  location = var.region

  template {
    spec {
      containers {
        image = "${var.artifact_registry_path}/${var.docker_image_name}:latest"
        ports {
          container_port = 6789
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}


#=======Compute Engine=======
resource "google_compute_instance" "default" {
  provider     = google
  name         = "default"
  machine_type = "e2-micro"

  metadata = {
    ssh-keys = "${var.project_id}:${var.credentials}"
  }

  network_interface {
    network = "default"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20220712"
    }
  }

  allow_stopping_for_update = true
}
