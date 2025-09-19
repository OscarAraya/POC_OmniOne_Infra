# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.main.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.main.token
# }

# provider "flux" {
#   kubernetes = {
#     host                   = data.aws_eks_cluster.main.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
#     token                  = data.aws_eks_cluster_auth.main.token
#   }

#   git = {
#     url    = "https://github.com/${var.github_org}/${var.github_repository}.git"
#     branch = var.github_branch
#     http = {
#       username = "git"
#       password = var.github_token
#     }
#   }
# }