variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
  default     = "demo-devops"
}

variable "region" {
  description = "Region for resources like subnet"
  type        = string
  default     = "asia-southeast1"
}

variable "zone" {
  description = "Zone for zonal resources"
  type        = string
  default     = "asia-southeast1-a"
}

variable "gke_cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "my-gke-cluster"
}

variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = "my-vpc-network"
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "my-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "node_machine_type" {
  description = "Machine type for node pools"
  type        = string
  default     = "COS_CONTAINERD"
}

variable "node_pool_1_name" {
  description = "Name of nodes in node pool 1"
  type        = string
  default     = "my-node1"
}

variable "node_pool_2_name" {
  description = "Name of nodes in node pool 1"
  type        = string
  default     = "my-node2"
}

variable "node_pool_1_count" {
  description = "Number of nodes in node pool 1"
  type        = number
  default     = 1
}

variable "node_pool_2_count" {
  description = "Number of nodes in node pool 2"
  type        = number
  default     = 1
}

variable "base_cidr" {
  type = string
  default = "10"
}