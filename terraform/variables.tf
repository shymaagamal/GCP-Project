variable "project_id" {
  description = "project ID"
  type        = string
}

variable "region" {
  description = " region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = " zone"
  type        = string
  default     = "us-central1-a"
}

variable "name-prefix" {
    description = "prefix for resource names"
    type = string 
    default = "shaimaa"
  
}

variable "artifact_location" {
  description = "Region of Artifact Registry"
  default     = "us-central1"
}

variable "gke_sa_email" {
  description = "Service Account email for GKE nodes "
  type        = string
  default     = ""
}
