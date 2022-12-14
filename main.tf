module "eks_cluster_primary" {
    source = "./modules/eks"

    name   = "nwales_eks_primary"
    region = "us-east-2"
}

# module "eks_cluster_secondary" {
#     source = "./modules/eks"

#     name   = "nwales_eks_secondary"
#     region = "us-west-2"
# }

# module "gke_cluster" {
#     source = "./modules/gke"

#     project_id = var.project_id
#     region     = var.gke_region
# }