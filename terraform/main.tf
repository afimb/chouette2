# Contains main description of bulk of terraform?
terraform {
  required_version = ">= 0.13.2"
}

provider "google" {
  version = "~> 3.74.0"
  region  = var.gcp_region
}
provider "kubernetes" {
  load_config_file = var.load_config_file
  version = "~> 1.13.4"
}

# create service account
resource "google_service_account" "chouette2_service_account" {
  account_id   = "${var.labels.team}-${var.labels.app}-sa"
  display_name = "${var.labels.team}-${var.labels.app} service account"
  project = var.gcp_resources_project
}

# add service account as member to the cloudsql client
resource "google_project_iam_member" "cloudsql_iam_member" {
  project = var.gcp_cloudsql_project
  role    = var.service_account_cloudsql_role
  member = "serviceAccount:${google_service_account.chouette2_service_account.email}"
}

# create key for service account
resource "google_service_account_key" "chouette2_service_account_key" {
  service_account_id = google_service_account.chouette2_service_account.name
}

  # Add SA key to to k8s
resource "kubernetes_secret" "chouette2_service_account_credentials" {
  metadata {
    name      = "${var.labels.team}-${var.labels.app}-sa-key"
    namespace = var.kube_namespace
  }
  data = {
    "credentials.json" = base64decode(google_service_account_key.chouette2_service_account_key.private_key)
  }
}

# Redis server
module "redis" {
  source = "github.com/entur/terraform//modules/redis?ref=v0.0.33"
  gcp_project = var.redis_project
  labels = var.labels
  kubernetes_namespace = var.kube_namespace
  zone = var.redis_zone
  reserved_ip_range = var.redis_reserved_ip_range
}


resource "kubernetes_secret" "ror-chouette2-secret" {
  metadata {
    name      = "${var.labels.team}-${var.labels.app}-secret"
    namespace = var.kube_namespace
  }

  data = {
    "chouette2-secret-key-base" = var.ror-chouette2-secret-key-base
    "chouette2-devise-secret-key" = var.ror-chouette2-devise-secret-key
    "chouette2-db-username" = var.ror-chouette2-db-username
    "chouette2-db-password" = var.ror-chouette2-db-password
  }
}
