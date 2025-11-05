resource "kubernetes_deployment" "roca_web" {
  metadata {
    name = "roca-web"
    labels = {
      app = "roca-web"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "roca-web"
      }
    }

    template {
      metadata {
        labels = {
          app = "roca-web"
        }
      }

      spec {
        container {
          name  = "roca-web"
          image = "yasnacf/rocamotors:v9" # cambia luego por tu imagen personalizada
          port {
            container_port = 80
          }

          # Si tienes tu HTML RoCa Motors en una imagen Docker personalizada
          # por ejemplo "yasnacf/rocamotors:v1"
          # reemplaza esta línea por:
          # image = "yasnacf/rocamotors:v4"
        }
      }
    }
  }
}

# Service tipo LoadBalancer para exponer la web públicamente
resource "kubernetes_service" "roca_web_lb" {
  metadata {
    name = "roca-web-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.roca_web.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

output "roca_web_endpoint" {
  value = kubernetes_service.roca_web_lb.status[0].load_balancer[0].ingress[0].hostname
}
