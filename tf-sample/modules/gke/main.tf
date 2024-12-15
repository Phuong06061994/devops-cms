resource "google_compute_subnetwork" "custom" {
  name          = "gke-custom"
  ip_cidr_range = var.secondary_ip_range
  region        = var.region
  network       = var.network_name
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.1.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.64.0/22"
  }
}


resource "google_service_account" "gke_service_account" {
  account_id   = "gke-custom-sa"
  display_name = "GKE Custom Service Account"
}

resource "google_project_iam_member" "gke_service_account_roles" {
  for_each = toset([
    "roles/container.admin",
    "roles/iam.serviceAccountUser",
    "roles/compute.admin",
    "roles/storage.admin",
    "roles/iam.workloadIdentityUser"
  ])

  project = var.project_id
  member  = "serviceAccount:${google_service_account.gke_service_account.email}"
  role    = each.value
}

resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.region
  networking_mode          = "VPC_NATIVE"
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false
  network                  = var.network_name
  subnetwork               = google_compute_subnetwork.custom.id
  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = google_compute_subnetwork.custom.secondary_ip_range.0.range_name

  }
  node_config {
    service_account = google_service_account.gke_service_account.email
    machine_type    = var.machine_type
    disk_size_gb    = 100
    disk_type       = "pd-standard"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  enable_multi_networking = true
  datapath_provider       = "ADVANCED_DATAPATH"
  depends_on              = [google_compute_subnetwork.custom]
}

#### GKE Node Pool Service Account
resource "google_service_account" "node_pool" {
  account_id   = "nodepool-sa"
  display_name = "Node Pool Service Account"
}

resource "google_container_node_pool" "primary_nodes_1" {
  name       = "nodepool-1"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = var.node_pool_1_count

  node_config {
    machine_type    = var.machine_type
    service_account = google_service_account.node_pool.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  depends_on = [google_container_cluster.primary]
}

