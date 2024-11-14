variable "kubeconfig_path" {
  description = "Kubeconfig Path"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kubernetes Context to Use"
  type        = string
  default     = ""
}

variable "deploy_method" {
  description = "Choose Deploy Method ArgpCD or Helm"
  type        = string
}

variable "argocd_server" {
  description = "ArgoCD Server URL"
  type        = string
  default     = ""

  validation {
    condition     = !(lower(var.deploy_method) == "argocd" && var.argocd_server == "")
    error_message = "ArgoCD Server URL Must Not be NULL When Deploy Method is ArgoCD."
  }
}

variable "argocd_token" {
  description = "ArgoCD Token"
  type        = string
  sensitive   = true
  default     = ""

  validation {
    condition     = !(lower(var.deploy_method) == "argocd" && var.argocd_token == "")
    error_message = "ArgoCD Token Must Not be NULL When Deploy Method is ArgoCD."
  }
}

variable "tls_verify_skip" {
  description = "Skip SelfSigned Certificates Validate"
  type        = bool
  default     = false
}

variable "namespace_name" {
  description = "Namespace Name"
  type        = string
  default     = "headlamp"
}

variable "argocd_namespace" {
  description = "ArgoCD Namespace"
  type        = string
  default     = "argocd"
}

variable "cluster_url" {
  description = "Cluster URL"
  type        = string
  default     = "https://kubernetes.default.svc"
}

variable "helm_chart_name" {
  description = "Helm Chart Name"
  type        = string
  default     = "headlamp"
}

variable "helm_chart_repo" {
  description = "Helm Chart Repo"
  type        = string
  default     = "https://headlamp-k8s.github.io/headlamp/"
}

variable "helm_chart_version" {
  description = "Helm Chart Version"
  type        = string
  default     = "0.26.0"
}

variable "helm_custom_values" {
  description = "Use Helm Custom Values"
  type        = bool
  default     = false
}

variable "helm_custom_values_path" {
  description = "Helm Custom Values Path"
  type        = string
  default     = ""

  validation {
    condition     = !(var.helm_custom_values && var.helm_custom_values_path == "")
    error_message = "Helm Custom Values Path must not be null when Helm Custom Values is true."
  }
}

variable "client_secret" {
  description = "OIDC Client Secret"
  type        = string
  sensitive   = true
}

variable "create_tls_secret" {
  description = "Create TLS Secret"
  type        = bool
  default     = false
}

variable "tls_secret_name" {
  description = "TLS Secret Name"
  type        = string
  default     = ""

  validation {
    condition     = !(var.create_tls_secret && var.tls_secret_name == "")
    error_message = "TLS Secret Name must not be null when Create TLS Secret is true."
  }
}

variable "tls_crt" {
  description = "TLS Crt Base64 Encoded"
  type        = string
  default     = ""

  validation {
    condition     = !(var.create_tls_secret && var.tls_crt == "")
    error_message = "TLS Crt must not be null when Create TLS Secret is true."
  }
}

variable "tls_key" {
  description = "TLS Key Base64 Encoded"
  type        = string
  sensitive   = true
  default     = ""

  validation {
    condition     = !(var.create_tls_secret && var.tls_key == "")
    error_message = "TLS Key must not be null when Create TLS Secret is true."
  }
}
