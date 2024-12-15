output "gke_cluster_name" {
  value = google_container_cluster.primary.name
}

output "gke_cluster_id" {
  value = google_container_cluster.primary.id
}
output "node_pool_1_name" {
  value = google_container_node_pool.primary_nodes_1.name
}

