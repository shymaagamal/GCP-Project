output "gke_cluster_name" {
  value = google_container_cluster.private_gke_cluster.name
}

output "gke_endpoint" {
  value = google_container_cluster.private_gke_cluster.endpoint
}
