resource "mongodbatlas_project" "main" {
  org_id = var.org_id
  name   = var.project-name
}

resource "mongodbatlas_network_container" "main" {
  project_id            = mongodbatlas_project.main.id
  atlas_cidr_block = var.atlas_cidr_block
  provider_name    = var.provider_name
  region_name           = var.mongodb_region
}

resource "mongodbatlas_cluster" "main" {
  project_id   = mongodbatlas_project.main.id
  name         = var.cluster_name
  cluster_type = "REPLICASET"
  replication_specs {
    num_shards = 1
    regions_config {
      region_name     = var.mongodb_region
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }
  
  cloud_backup = false
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "6.0"

  # Provider Settings "block"
  provider_name               = "AWS"
  provider_instance_size_name = "M0"

  depends_on            = [ mongodbatlas_network_container.main ]
}

resource "mongodbatlas_database_user" "main" {
  username           = var.db_username
  password           = var.db_password
  project_id         = mongodbatlas_project.main.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "dbforApp"
  }

  roles {
    role_name     = "readAnyDatabase"
    database_name = "admin"
  }

  labels {
    key   = "Env"
    value = "Production"
  }

}


resource "mongodbatlas_network_peering" "main" {
  accepter_region_name   = var.accepter_region_name
  project_id             = mongodbatlas_project.main.id
  container_id           = mongodbatlas_network_container.main.id
  provider_name          = var.provider_name
  route_table_cidr_block = var.route_table_cidr_block_aws
  vpc_id                 = var.vpc_id_aws
  aws_account_id         = var.aws_account_id
}

# Accept the peering connection request
resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = mongodbatlas_network_peering.main.connection_id
  auto_accept = true
}

#allows traffic to be routed between those two VPCs properly
resource "aws_route" "main" {
  route_table_id            = var.aws_route_table_id
  destination_cidr_block    = mongodbatlas_network_container.main.atlas_cidr_block
  vpc_peering_connection_id = mongodbatlas_network_peering.main.connection_id
}

resource "mongodbatlas_project_ip_access_list" "main" {
  project_id     = mongodbatlas_project.main.id
  cidr_block = var.aws_vpc_cidr_block
  comment    = "Whitelist for the AWS VPC"
}
