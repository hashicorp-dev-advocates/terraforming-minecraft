variable "gitlab_version" {
  default = "15.1.3-ce.0"
}

variable "gitlab_password" {
  default = "password"
}

variable "gitlab_url" {
  default = "localhost"
}

container "gitlab" {
  network {
    name = "network.main"
  }

  image {
    name = "gitlab/gitlab-ce:${var.gitlab_version}"
  }

  port {
    local  = 443
    remote = 443
    host   = 443
  }

  port {
    local  = 80
    remote = 80
    host   = 80
  }

  port {
    local  = 22
    remote = 22
    host   = 22
  }

  env {
    key = "GITLAB_ROOT_PASSWORD"
    value = var.gitlab_password
  }

  env {
    key = "EXTERNAL_URL"
    value = var.gitlab_url
  }

  health_check {
    timeout = "300s"
    http    = "${var.gitlab_url}/users/sign_in"
  }
}

exec_local "setup" {
  depends_on = ["container.gitlab"]

  cmd = "${file_dir()}/files/setup.sh"

  env {
    key = "GITLAB_PASSWORD"
    value = var.gitlab_password
  }

  env {
    key = "GITLAB_URL"
    value = var.gitlab_url
  }

  timeout = "60s"
}

output "gitlab" {
  value = var.gitlab_url
}
