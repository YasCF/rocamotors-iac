module "vpc" {
  source   = "./modules/vpc"
  vpc_name = "roca-vpc"
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = "roca-eks"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.subnet_ids
}

module "alb" {
  source     = "./modules/alb"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
  depends_on = [module.vpc]
}

module "sns" {
  source      = "./modules/sns"
  topic_name  = "roca-alerts"
  alert_email = "tucorreo@dominio.com" # cambiar por tu email
}

module "cloudwatch" {
  source         = "./modules/cloudwatch"
  log_group_name = "/roca/eks"
  sns_topic_arn  = module.sns.topic_arn
}
module "webapp" {
  source     = "./modules/webapp"
  depends_on = [module.eks]
}

# DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "tf_locks" {
  name         = "tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "tf-locks"
  }
}
