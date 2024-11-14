resource "kubernetes_namespace" "headlamp_namespace" {
  metadata {
    name = var.namespace_name
  }
}

locals {
  use_custom_values = var.helm_custom_values ? templatefile(var.helm_custom_values_path, {
    client_secret = var.client_secret,
  }) : ""
}

resource "argocd_application" "headlamp" {
  count = lower(var.deploy_method) == "argocd" ? 1 : 0

  metadata {
    name      = var.helm_chart_name
    namespace = var.argocd_namespace
  }

  spec {
    destination {
      server    = var.cluster_url
      namespace = kubernetes_namespace.headlamp_namespace.metadata[0].name
    }

    sync_policy {
      automated {}
    }

    source {
      repo_url        = var.helm_chart_repo
      chart           = var.helm_chart_name
      target_revision = var.helm_chart_version

      helm {
        values = local.use_custom_values
      }
    }
  }
}

resource "helm_release" "headlamp" {
  count = lower(var.deploy_method) == "helm" ? 1 : 0

  namespace  = kubernetes_namespace.headlamp_namespace.metadata[0].name
  name       = var.helm_chart_name
  chart      = var.helm_chart_name
  repository = var.helm_chart_repo
  version    = var.helm_chart_version

  values = var.helm_custom_values ? [local.use_custom_values] : []
}

resource "kubernetes_manifest" "tls_certificate_secret" {
  count = var.create_tls_secret == true ? 1 : 0

  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Secret"
    "metadata" = {
      "name"      = var.tls_secret_name
      "namespace" = var.namespace_name
    }
    "type" = "kubernetes.io/tls"
    "data" = {
      "tls.crt" = var.tls_crt
      "tls.key" = var.tls_key
    }
  }
}
