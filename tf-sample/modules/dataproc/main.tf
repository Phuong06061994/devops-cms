resource "google_service_account" "dataproc_sa" {
  account_id   = "dataproc-gke-sa"
  display_name = "Dataproc GKE Service Account"
}


resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.dataproc_sa.name
  role               = "roles/iam.workloadIdentityUser"
  
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[dataproc-cluster/agent]"
  ]
}

resource "google_dataproc_cluster" "mycluster" {
  name   = var.dataproc_cluster_name
  region = var.region

  cluster_config {
    staging_bucket = var.bucket_name
  }

  virtual_cluster_config {
    kubernetes_cluster_config {
      kubernetes_namespace = "dataproc-cluster"

      kubernetes_software_config {
        component_version = {
          "SPARK" = "3.5-dataproc-19"
        }
      }

      gke_cluster_config {
        gke_cluster_target = var.gke_cluster_id

        node_pool_target {
          node_pool = "dataproc-node"
          roles     = ["DEFAULT", "CONTROLLER", "SPARK_DRIVER", "SPARK_EXECUTOR"]

          node_pool_config {
            autoscaling {
              min_node_count = 1
              max_node_count = 6
            }

            config {
              machine_type     = "n1-standard-4"
              preemptible      = true
              local_ssd_count  = 1
              min_cpu_platform = "Intel Sandy Bridge"
            }
            locations = ["asia-southeast1-a"]
          }
        }
      }
    }
  }
}
