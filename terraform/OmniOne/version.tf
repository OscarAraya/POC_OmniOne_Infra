terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.79"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
    kubernetes = { 
      source = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
    flux = {  
      source  = "fluxcd/flux"
      version = ">= 1.2" 
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.1"
    }
  }
}

provider "aws" {
  region = var.region
}