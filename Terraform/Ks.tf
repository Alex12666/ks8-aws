module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "meu-cluster-eks"
  kubernetes_version = "1.30"

  endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  authentication_mode = "API_AND_CONFIG_MAP"

  create_auto_mode_iam_resources = true

  compute_config = {
    enabled = true
  }


  vpc_id = aws_vpc.my-vpc.id


  subnet_ids = [
    aws_subnet.my-sbp.id,
    aws_subnet.my-sbp-2.id
  ]

  tags = {
    Environment = "testetando conecimentos ks8 aws"
    Terraform   = "true"
  }
}