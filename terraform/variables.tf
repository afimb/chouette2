#Enviroment variables
variable "gcp_project" {
    description = "The GCP project id"
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

variable "ror-chouette-db-username" {
  description = "chouette database username"
}

variable "ror-chouette-db-password" {
  description = "chouette database password"
}

variable "ror-chouette2-secret-key-base" {
  description = "chouette2 secret key base"
}

variable "ror-chouette2-devise-secret-key" {
  description = "chouette2 devise secret key"
}

