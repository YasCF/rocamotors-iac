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

provider "kubernetes" {
  host                   = try(data.aws_eks_cluster.cluster.endpoint, "")
  cluster_ca_certificate = try(base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data), "")
  token                  = try(data.aws_eks_cluster_auth.cluster.token, "")
}
