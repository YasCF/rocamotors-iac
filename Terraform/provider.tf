terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }

  backend "s3" {
    bucket         = "roca-bucket-aws"
    key            = "terraform/rocamotors-iac.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tf-locks"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "time_sleep" "wait_for_cluster" {
  depends_on = [module.eks]
  create_duration = "60s"
}

data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [time_sleep.wait_for_cluster]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [time_sleep.wait_for_cluster]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
