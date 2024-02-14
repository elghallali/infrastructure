module "docker_install" {
  source = "./modules/docker_install"
  ssh_host = var.ssh_host
  ssh_user = var.ssh_user
  ssh_key = var.ssh_key
}

module "kubernetes_install_worker" {
  source = "./modules/kubernetes_install_worker"
}

module "kubernetes_install_master" {
  source = "./modules/kubernetes_install_master"
}

module "kubeflow_install" {
  source = "./modules/kubeflow_install"
}