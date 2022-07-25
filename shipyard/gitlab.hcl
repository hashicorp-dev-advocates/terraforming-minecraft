variable "gitlab_version" {
  default = "15.1.3-ce.0"
}

variable "gitlab_password" {
  default = "password"
}

variable "gitlab_url" {
  default = "localhost"
}

variable "gitlab_host" {
  default = "localhost"
}

template "gitlab" {
  source = <<EOT
  external_url '${var.gitlab_url}'
  gitlab_rails['gitlab_host'] = '${var.gitlab_host}'
  EOT
  destination = "${data("gitlab")}/gitlab.rb"
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
    key = "GITLAB_OMNIBUS_CONFIG"
    value = "external_url '${var.gitlab_url}'; gitlab_rails['gitlab_host'] = '${var.gitlab_host}';"
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
    key = "GITLAB_URL"
    value = var.gitlab_url
  }

  env {
    key = "GITLAB_PASSWORD"
    value = var.gitlab_password
  }

  timeout = "60s"
}

output "gitlab" {
  value = var.gitlab_url
}
