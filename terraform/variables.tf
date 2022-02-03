#Enviroment variables
variable "gcp_project" {
  description = "The GCP project hosting the workloads"
}

variable "gcp_region" {
  description = "The GCP region"
  default     = "europe-west1"
}

variable "gcp_cloudsql_project" {
  description = "The GCP project hosting the CloudSQL resources"
}

variable "gcp_resources_project" {
  description = "The GCP project hosting the project resources"
}

variable "location" {
  description = "GCP bucket location"
}
variable "kube_namespace" {
  description = "The Kubernetes namespace"
}

variable "labels" {
  description = "Labels used in all resources"
  type        = map(string)
     default = {
       manager = "terraform"
       team    = "ror"
       slack   = "talk-ror"
       app     = "chouette2"
     }
}

variable "force_destroy" {
  description = "(Optional, Default: false) When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run"
  default     = false
}

variable "prevent_destroy" {
  description = "Prevent destruction of bucket"
  type        = bool
  default     = false
}

variable "load_config_file" {
  description = "Do not load kube config file"
  default     = false
}

variable "service_account_cloudsql_role" {
  description = "Role of the Service Account - more about roles https://cloud.google.com/pubsub/docs/access-control"
  default     = "roles/cloudsql.client"
}

variable "redis_project" {
  description = "The GCP project for redis"
}

variable "redis_zone" {
  description = "The GCP zone for redis"
  default = "europe-west1-d"
}

variable "redis_reserved_ip_range" {
  description = "IP range for Redis, follow addressing scheme"
}

variable "ror-chouette2-db-username" {
  description = "chouette2 database username"
}

variable "ror-chouette2-db-password" {
  description = "chouette2 database password"
}

variable "ror-chouette2-secret-key-base" {
  description = "chouette2 secret key base"
}

variable "ror-chouette2-devise-secret-key" {
  description = "chouette2 devise secret key"
}

