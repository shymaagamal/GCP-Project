output "vpc_network" {
  value = google_compute_network.shaimaa_custom_vpc.name
}

output "management_subnet" {
  value = google_compute_subnetwork.management_subnet.name
}

output "restricted_subnet" {
  value = google_compute_subnetwork.restricted_subnet.name
}

output "private_vm_ip" {
  value = google_compute_instance.private_vm.network_interface[0].network_ip
}

output "gke_endpoint" {
  value = module.gke.gke_endpoint
}

output "artifact_registry_repo" {
  value = google_artifact_registry_repository.app_repo.repository_id
}


