terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "helm" {
  alias = "helm"
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "vpc" {
  source             = "../modules/aws/vpc"
  env                = var.env
  count              = var.create_vpc ? 1 : 0
  building_block     = var.building_block
  region             = var.region
  availability_zones = var.availability_zones
}

module "eks" {
  source                        = "../modules/aws/eks"
  env                           = var.env
  building_block                = var.building_block
  depends_on                    = [module.vpc]
  region                        = var.region
  cluster_logs_enabled          = var.cluster_logs_enabled
  eks_master_subnet_ids         = var.create_vpc ? module.vpc[0].multi_zone_public_subnets_ids : var.eks_master_subnet_ids
  eks_nodes_subnet_ids          = var.create_vpc ? module.vpc[0].single_zone_public_subnets_id : var.eks_nodes_subnet_ids
  eks_node_group_instance_type  = var.eks_node_group_instance_type
  eks_node_group_capacity_type  = var.eks_node_group_capacity_type
  eks_node_group_scaling_config = var.eks_node_group_scaling_config
  eks_node_disk_size            = var.eks_node_disk_size
  eks_endpoint_private_access   = var.eks_endpoint_private_access
}

module "iam" {
  source                = "../modules/aws/iam"
  env                   = var.env
  building_block        = var.building_block
}

module "s3" {
  count          = var.create_s3_buckets ? 1 : 0
  source         = "../modules/aws/s3"
  env            = var.env
  building_block = var.building_block
}

module "flowlogs" {
  count                      = var.flowlogs_enabled ? 1 : 0
  source                     = "../modules/aws/flowlogs"
  env                        = var.env
  building_block             = var.building_block
  vpc_id                     = var.create_vpc ? module.vpc[0].vpc_id : var.vpc_id
  flowlogs_retention_in_days = var.flowlogs_retention_in_days
}

module "eip" {
  source         = "../modules/aws/eip"
  env            = var.env
  building_block = var.building_block
}

module "eks_storage_class" {
  source         = "../modules/helm/eks_storage_class"
  env            = var.env
  building_block = var.building_block
  depends_on     = [module.eks]
}

module "get_kubeconfig" {
  source         = "../modules/aws/get_kubeconfig"
  env            = var.env
  building_block = var.building_block
  region         = var.region
}
