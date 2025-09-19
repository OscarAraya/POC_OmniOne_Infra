variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "OmniOne"
}

variable "github_org" {
  description = "Github Owner"
  type        = string
  default     = "OscarAraya"
}

variable "github_token" {
  description = "Github Token"
  type        = string
}

variable "github_repository" {
  description = "Github Repository name"
  type        = string
  default     = "AWS_EKS_Flux_GitOps"
}

variable "github_branch" {
  description = "Default branch used for Flux bootstrapping"
  type        = string
  default     = "main"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
  default     = "1.33"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_access_cidrs" {
  description = "CIDRs allowed to reach the EKS public API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"] # CHANGE THIS to your IP, e.g. ["203.0.113.10/32"]
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 2
}

variable "instance_types" {
  description = "Instance types for node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "ssh_pub_key" {
  description = "Optional SSH public key to enable SSH into worker nodes (e.g. 'ssh-rsa AAAA... user@host')"
  type        = string
  default     = ""
}

variable "ec2_key_name" {
  description = "Name of an existing EC2 key pair in this AWS account/region (no .pem)"
  type        = string
  default     = "soni-cloud"
}