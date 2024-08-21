job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "mysql" {

    network {
      [[ if var "register_consul_service" . ]]
      mode = "bridge"
      [[ end ]]
      port "mysql" {
        to = 3306
      }
    }

    [[ if var "register_consul_service" . ]]
    service {
      name = "[[ var "consul_service_name" . ]]"
      [[ range $tag := var "consul_service_tags" . ]]
      tags = [[ var "consul_service_tags" . | toStringList ]]
      [[ end ]]
      port = "mysql"
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 3306
          }
        }
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
        image = "mysql:[[ var "version_tag" . ]]"
        ports = ["mysql"]
      }

      [[ template "env_upper" . ]]

      [[ template "resources" . ]]
    }
  }
}
