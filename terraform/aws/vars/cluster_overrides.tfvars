building_block               = "aml-dev"
env                          = "test"
region                       = "ap-south-1"
availability_zones           = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
timezone                     = "UTC"
create_vpc                   = "true"
vpc_id                       = ""
eks_nodes_subnet_ids         = [""]
eks_master_subnet_ids        = [""]

# cluster sizing
eks_endpoint_private_access  = false
eks_node_group_instance_type = ["t2.small"]
eks_node_group_capacity_type = "ON_DEMAND"
eks_node_group_scaling_config = {
  desired_size = 2
  max_size     = 2
  min_size     = 1
}
# Disk node size in gb
eks_node_disk_size = 30

create_iam = true

create_s3_buckets = true
s3_buckets = {
  "s3_bucket"                 = "",
  "s3_backups_bucket"         = ""
}

