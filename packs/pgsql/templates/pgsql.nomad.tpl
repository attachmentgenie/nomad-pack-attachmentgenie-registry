job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "pgsql" {
    count = [[ var "app_count" . ]]

    network {
      [[ if var "register_service" . ]]
      [[  $service_provider := var "service_provider" . ]]
      [[ if eq $service_provider "consul" ]]
      mode = "bridge"
      [[ end ]]
      [[ end ]]
      port "pgsql" {
        to = 5432
      }
    }

    [[ if var "register_service" . ]]
    service {
      name     = "[[ var "service_name" . ]]"
      provider = "[[ var "service_provider" . ]]"
      [[ range $tag := var "service_tags" . ]]
      tags     = [[ var "service_tags" . | toStringList ]]
      [[ end ]]
      port     = "pgsql"
      [[ if var "service_connect_enabled" . ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 5432
          }
        }
      }
      [[ end ]]
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
        image   = "[[ var "task.image" . ]]:[[ var "task.version" . ]]"
        ports   = ["pgsql"]
      }

      [[ template "env_upper" . ]]

      [[ template "resources" . ]]
    }
  }
}
