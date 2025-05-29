# VPC
resource "google_compute_network" "shaimaa_custom_vpc" {
  name                    = "${var.name-prefix}-vpc"
  auto_create_subnetworks = false
}

# Subnets
resource "google_compute_subnetwork" "management_subnet" {
  name          = "${var.name-prefix}-management-subnet"
  ip_cidr_range = "10.10.1.0/24"
  region        = var.region
  network       = google_compute_network.shaimaa_custom_vpc.id
}

resource "google_compute_subnetwork" "restricted_subnet" {
  name          = "${var.name-prefix}-restricted-subnet"
  ip_cidr_range = "10.10.2.0/24"
  region        = var.region
  network       = google_compute_network.shaimaa_custom_vpc.id

}

# Cloud Router
resource "google_compute_router" "nat_router" {
  name    = "${var.name-prefix}-nat-router"
  region  = var.region
  network = google_compute_network.shaimaa_custom_vpc.name
}
# NAT Gateway
resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${var.name-prefix}-nat-config"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.management_subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# Private VM
data "google_compute_image" "ubuntu_image" {
  project = "ubuntu-os-cloud"
  family  = "ubuntu-2204-lts"
}

resource "google_service_account" "vm_sa" {
  account_id   = "${var.name-prefix}-vm-sa"
  display_name = "${var.name-prefix}-vm-sa"
}

resource "google_project_iam_member" "vm_sa_roles" {
  for_each = toset([
    "roles/container.developer",
    "roles/container.clusterAdmin",
    "roles/artifactregistry.admin",
    "roles/iam.serviceAccountUser"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.vm_sa.email}"
}

resource "google_compute_instance" "private_vm" {
  name         = "${var.name-prefix}-private-vm"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_image.self_link
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.management_subnet.name
  }

  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }

  tags = ["iap-access"]

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y git docker.io
    curl -sSL https://sdk.cloud.google.com | bash
    echo "export PATH=$PATH:/root/google-cloud-sdk/bin" >> /root/.bashrc
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/
  EOF
}

# Artifact Registry repository
resource "google_artifact_registry_repository" "app_repo" {
  location      = var.region
  repository_id = "${var.name-prefix}-app-repo"
  format        = "DOCKER"
  description   = "Private Docker repo for GKE app"
  mode          = "STANDARD_REPOSITORY"
}


module "gke" {
  source                 = "./gke"
  name-prefix            = var.name-prefix
  project_id             = var.project_id
  zone                   = var.zone
  vpc_name               = google_compute_network.shaimaa_custom_vpc.name
  restricted_subnet_name = google_compute_subnetwork.restricted_subnet.name
  management_cider_block = "10.10.1.0/24"
}
