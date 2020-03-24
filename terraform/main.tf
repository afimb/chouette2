# Contains main description of bulk of terraform?
terraform {
  required_version = ">= 0.12"
}

provider "google" {
  version = "~> 2.19"
}
provider "kubernetes" {
  load_config_file = var.load_config_file
}

# create service account
resource "google_service_account" "chouette2_service_account" {
  account_id   = "${var.labels.team}-${var.labels.app}-sa"
  display_name = "${var.labels.team}-${var.labels.app} service account"
  project = var.gcp_project
}

# add service account as member to the cloudsql client
resource "google_project_iam_member" "cloudsql_iam_member" {
  project = var.gcp_project
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
    "credentials.json" = "${base64decode(google_service_account_key.chouette2_service_account_key.private_key)}"
  }
}

resource "kubernetes_secret" "ror-chouette2-secret" {
  metadata {
    name      = "${var.labels.team}-${var.labels.app}-secret"
    namespace = var.kube_namespace
  }

  data = {
    "chouette2-secret-key-base" = var.ror-chouette2-secret-key-base
    "chouette2-devise-secret-key" = var.ror-chouette2-devise-secret-key
    "chouette-db-username" = var.ror-chouette-db-username
    "chouette-db-password" = var.ror-chouette-db-password
  }
}
