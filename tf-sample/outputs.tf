output "private_subnets_name" {
  description = "Private subnets"
  value       = module.network.private_subnets_name
}

output "gke_cluster_name" {
  value = module.gke_cluster.gke_cluster_name
}

output "gke_cluster_id" {
  value = module.gke_cluster.gke_cluster_id
}

output "bucket_name" {
  value = module.bucket.bucket_name
}

output "node_pool_1_name" {
  value = module.gke_cluster.node_pool_1_name
}
