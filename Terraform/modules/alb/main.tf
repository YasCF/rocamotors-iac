# ===============================
# Módulo ALB RoCa Motors
# ===============================

resource "aws_security_group" "alb_sg" {
  name        = "roca-alb-sg"
  description = "Permite trafico HTTP hacia el ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP publico"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Todo el trafico saliente permitido"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "roca-alb-sg"
    Project = "roca"
  }
}


# 🔹 Load Balancer
resource "aws_lb" "this" {
  name               = "roca-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.alb_sg.id] # 🔸 Mantiene siempre al menos un SG

  enable_deletion_protection = false

  tags = {
    Name    = "roca-alb"
    Project = "roca"
  }
}

# 🔹 Target group (opcional, si lo necesitas para EKS)
resource "aws_lb_target_group" "tg" {
  name     = "roca-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "roca-tg"
  }
}

# 🔹 Listener HTTP
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
