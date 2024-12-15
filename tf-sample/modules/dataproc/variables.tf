# Define Terraform Variables
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region for the GKE Cluster"
  type        = string
}
variable "gke_cluster_name" {
  description = "The name of the existing GKE cluster"
  type        = string
}

variable "gke_cluster_id" {
  description = "The name of the existing GKE cluster"
  type        = string
}

variable "dataproc_cluster_name" {
  description = "The name of the Dataproc cluster"
  type        = string
  default     = "dataproc-gke-cluster"
}

variable "namespace" {
  description = "The Kubernetes namespace for Dataproc"
  type        = string
  default     = "default"
}

variable "bucket_name" {
  type = string
}

variable "node_pool_1_name" {
  type = string
}