resource "google_compute_firewall" "allow_internal" {
  name    = "${var.name-prefix}allow-internal"
  network = google_compute_network.shaimaa_custom_vpc.name

  direction     = "INGRESS"
  priority      = 65534
  source_ranges = ["10.10.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow_ssh_management" {
  name    = "shaimaa-allow-ssh-management-subnet"
  network = google_compute_network.shaimaa_custom_vpc.name

  direction = "INGRESS"
  priority  = 100

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["iap-access"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_health_checks" {
  name    = "shaimaa-allow-gcp-health-checks"
  network = google_compute_network.shaimaa_custom_vpc.name

  direction = "INGRESS"
  priority  = 1000
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }
}

resource "google_compute_firewall" "allow_gke_node_ports" {
  name    = "shaimaa-allow-gke-node-ports"
  network = google_compute_network.shaimaa_custom_vpc.name

  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["10.10.0.0/16"]

  target_tags = ["gke-node"]

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }
}
