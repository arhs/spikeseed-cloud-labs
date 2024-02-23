resource "kubernetes_pod" "ng" {
  metadata {
    name = "ng"
    labels = {
      app = "ng"
    }
  }

  spec {
    container {
      image = "nginx"
      name  = "ng"
      port {
        container_port = 80
      }
    }
  }
}

resource "kubernetes_service" "ng" {
  metadata {
    name = "ng"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
      "service.beta.kubernetes.io/aws-load-balancer-name"            = "alb-controller-test"
      "service.beta.kubernetes.io/aws-load-balancer-scheme"          = "internet-facing"
    }
  }
  spec {
    selector = {
      app = kubernetes_pod.ng.metadata[0].labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
