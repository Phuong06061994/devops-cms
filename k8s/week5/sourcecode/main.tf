# Provider Configuration
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Enable Required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "compute.googleapis.com",   # Required for VPC and Subnet
    "container.googleapis.com", # Required for GKE
    "iam.googleapis.com"        # Required for Service Accounts
  ])
  project = var.project_id
  service = each.key

  disable_on_destroy = false  # Prevent disabling services
}

# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.self_link  # Use self_link for network

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.1.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.64.0/22"
  }
}

# GKE Cluster
resource "google_container_cluster" "my_cluster" {
  name               = var.gke_cluster_name
  location           = var.zone
  initial_node_count = 1
  network            = google_compute_network.vpc_network.self_link  # Use self_link for network
  subnetwork         = google_compute_subnetwork.subnet.self_link    # Use self_link for subnetwork
  remove_default_node_pool = true
  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = "services-range"  # Directly reference range names
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
}

# Node Pool
resource "google_container_node_pool" "linux_pool_1" {
  name     = var.node_pool_1_name
  cluster  = google_container_cluster.my_cluster.name
  location = google_container_cluster.my_cluster.location
  initial_node_count = 1
  node_config {
    image_type = var.node_machine_type  # Use a valid GCP image type
  }
}

# Node Pool
resource "google_container_node_pool" "linux_pool_2" {
  name     = var.node_pool_2_name
  cluster  = google_container_cluster.my_cluster.name
  location = google_container_cluster.my_cluster.location
  initial_node_count = 1
  node_config {
    image_type = var.node_machine_type  # Use a valid GCP image type
  }
}
