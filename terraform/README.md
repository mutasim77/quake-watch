# Terraform 🌍🔧
Terraform was used to build and manage GCP infrastructure. Here you can find the following files:

- **[variables.tf](./variables.tf):** contains variables to make your configuration more reproducible.
- **[main.tf](./main.tf):** is a key configuration file consisting of several sections.
- **[earthquake_schema.json](./earthquakes_schema.json):** contains the JSON schema for the Data Warehouse table.
- **[makefile](./makefile):** contains commands for automating project tasks.
- **[Dockerfile](./Dockerfile):** used to build an image for the application and store it in an artifact registry.


### [variables.tf](./variables.tf)
This file was used to define some of the variables that I used inside the *main.tf*. It's just good practice to keep them separate and also easy to manage.

> [!TIP] 
> If you use different names, make sure that you change them as well in the file.

### [main.tf](./main.tf)
This file was used to set up:

- ##### Data Lake:
  - Create a GCS bucket named "quakewatch" in the specified region
  - Set the storage class as specified by the variable
  - Enable uniform bucket-level access
  - Define a lifecycle rule to delete objects older than 120 days
  - Allow forceful deletion of the bucket and its contents when Terraform destroys the resource
   
- ##### Data Warehouse:
  - Create a BigQuery dataset named *earthquake_dataset*.
  - Create a BigQuery table *earthquake_data* (used to load data from the bucket quakewatch).
  - Define the schema for the table using the contents of the "earthquakes_schema.json" file.
  - Allow deletion of the table even if it's protected against deletion at the dataset level.

- ##### Cloud Run:
  - Build the Docker image
  - Tag the Docker image with the Artifact Registry path
  - Push the Docker image to the Artifact Registry
  - Deploy the Cloud Run service

- ##### Compute Engine:
  - Create a Compute Engine instance with the specified machine type
  - Configure metadata for SSH keys
  - Attach the instance to the default network
  - Initialize the boot disk with the specified Ubuntu 20.04 image
  - Allow the instance to be stopped for updates if needed