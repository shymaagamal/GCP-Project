#  GKE Service Account
resource "google_service_account" "gke_nodes" {
  account_id   = "${var.name-prefix}gke-node-sa"
  display_name = "${var.name-prefix}gke-node-sa"
}

# Allow reading from Artifact Registry
resource "google_project_iam_member" "artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# GKE cluster
resource "google_container_cluster" "private_gke_cluster" {
  name       = "${var.name-prefix}-private-gke-cluster"
  location   = var.zone
  network    = var.vpc_name
  subnetwork = var.restricted_subnet_name

  initial_node_count = 2

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
    master_global_access_config {
      enabled = true
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.management_cider_block
      display_name = "Management Subnet"
    }
  }

  node_config {
    machine_type    = "e2-medium"
    service_account = google_service_account.gke_nodes.email
    tags            = ["gke-node-2"]
    disk_size_gb    = 30
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  logging_service     = "logging.googleapis.com/kubernetes"
  monitoring_service  = "monitoring.googleapis.com/kubernetes"
  deletion_protection = false
}
