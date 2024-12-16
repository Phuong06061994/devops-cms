# Fetch zones dynamically (requires the provider region to be set)
data "google_compute_zones" "available" {
  region = var.region
  project = var.project_id
}
 
 
# Local variables for zones
locals {
  zones = {
    for index, zone in data.google_compute_zones.available.names :
    zone => { index = index }
  }
}
 
# Enable required APIs
resource "google_project_service" "compute_api" {
  project = var.project_id
  service = "compute.googleapis.com"
}
 
# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "devops-network"
  project = var.project_id
  auto_create_subnetworks = false
}
 
 
# Subnet for each zone
resource "google_compute_subnetwork" "subnets" {
  for_each = local.zones
  name     = "subnet-${each.key}" # Subnet name includes zone for clarity
  ip_cidr_range = cidrsubnet(
    var.subnet_cidr,
    8,                     # Subnet bits (to divide into smaller subnets)
    each.value.index       # Assign index for unique subnets
  )
  region  = var.region
  project = var.project_id
  network = google_compute_network.vpc_network.id
}