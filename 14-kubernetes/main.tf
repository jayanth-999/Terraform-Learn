terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. Create Resource Group
resource "azurerm_resource_group" "k8s" {
  name     = "rg-k8s-demo"
  location = "East US"
}

# 2. Create AKS Cluster
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "aks-demo-cluster"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = "aksdemo"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s" # Cheap burstable instance
  }

  identity {
    type = "SystemAssigned"
  }
}

# 3. Configure Helm Provider to talk to the NEW cluster
# We use the outputs from the AKS resource to configure the provider dynamically.
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
  }
}

# 4. Deploy Nginx using Helm
resource "helm_release" "nginx" {
  name       = "nginx-ingress"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  version    = "15.0.0"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  timeout = 900 # Increase timeout to 15 minutes (Azure LB creation can be slow)
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config_raw
  sensitive = true
}
