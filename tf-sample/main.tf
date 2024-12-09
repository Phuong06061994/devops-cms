terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.12.0"
    }
  }
}


provider "google" {
  project = var.project_id
  region  = var.region
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

  disable_on_destroy = false # Prevent disabling services
}

module "network" {
  source               = "./modules/network"
  region               = var.region
  network_name         = var.network_name
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}



module "gke_cluster" {
  source = "./modules/gke"

  cluster_name = "devops-gke-cluster-02"
  region       = var.region
  network_name = module.network.vpc_id
  # cluster_secondary_range_name = "gke-secondary-range"
  # services_secondary_range_name = "gke-services-secondary-range"
  private_subnet_1  = module.network.private_subnets_name[1]
  private_subnet_2  = module.network.private_subnets_name[0]
  node_pool_1_count = 1
  node_pool_2_count = 1
  disk_size_gb = 10
  depends_on = [
    module.network.public_subnets
  ]
}
