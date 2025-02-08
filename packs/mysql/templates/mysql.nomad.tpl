job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "mysql" {

    network {
      [[ if var "register_service" . ]]
      [[  $service_provider := var "service_provider" . ]]
      [[ if eq $service_provider "consul" ]]
      mode = "bridge"
      [[ end ]]
      [[ end ]]
      port "mysql" {
        to = 3306
      }
    }

    [[ if var "register_service" . ]]
    service {
      name     = "[[ var "service_name" . ]]"
      provider = "[[ var "service_provider" . ]]"
      [[ range $tag := var "service_tags" . ]]
      tags     = [[ var "service_tags" . | toStringList ]]
      [[ end ]]
      port     = "mysql"
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
      driver = "[[ var "task.driver" . ]]"

      config {
        image = "[[ var "task.image" . ]]:[[ var "task.version" . ]]"
        ports = ["mysql"]
      }

      [[ template "env_upper" . ]]

      [[ template "resources" . ]]
    }
  }
}
