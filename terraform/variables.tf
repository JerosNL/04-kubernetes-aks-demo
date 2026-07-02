variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-aks-demo"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-demo-jh"
}

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 1
}

variable "node_size" {
  description = "VM size for worker nodes"
  type        = string
  default     = "Standard_B2als_v2"
}