resource "kubernetes_deployment" "app" {
  depends_on = [
    aws_eks_node_group.worker
  ]
  metadata {
    name = "app-deployment"
    labels = {
      app = "web-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "web-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "web-app"
        }
      }

      spec {
        container {
          name  = "web-app"
          image = "nginx:latest"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}