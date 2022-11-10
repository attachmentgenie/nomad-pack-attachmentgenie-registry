job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "mysql" {
    count = [[ .my.count ]]

    network {
      port "mysql" {
        to = 3306
      }
    }

    [[ if .my.register_consul_service ]]
    service {
      name = "[[ .my.consul_service_name ]]"
      tags = [[ .my.consul_service_tags | toStringList ]]
      check {
        name     = "alive"
        type     = "tcp"
        port     = "mysql"
        interval = "10s"
        timeout  = "2s"
      }
    }
    [[ end ]]

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "server" {
      driver = "docker"

      config {
        image = "mysql:[[ .my.version_tag ]]"
        ports = ["mysql"]
      }

      env {
        [[- range $var := .my.env_vars ]]
        [[ $var.key ]] = "[[ $var.value ]]"
        [[- end ]]
      }

      resources {
        cpu    = [[ .my.resources.cpu ]]
        memory = [[ .my.resources.memory ]]
      }
    }
  }
}
