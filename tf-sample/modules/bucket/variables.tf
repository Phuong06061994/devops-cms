variable "region" {
  description = "The region for the GKE Cluster"
  type        = string
}
variable "bucket_name" {
  description = "The name of the Google Cloud Storage bucket"
  type        = string
  default     = "phuongnv63"
}


variable "storage_class" {
  description = "The storage class of the bucket"
  type        = string
  default     = "STANDARD"
}

variable "versioning_enabled" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}

variable "retention_days" {
  description = "Number of days before auto-deletion"
  type        = number
  default     = 365
}
