job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "pgsql" {
    count = [[ var "app_count" . ]]

    network {
      [[ if var "register_consul_service" . ]]
      mode = "bridge"
      [[ end ]]
      port "pgsql" {
        to = 5432
      }
    }

    [[ if var "register_consul_service" . ]]
    service {
      name = "[[ var "consul_service_name" . ]]"
      [[ range $tag := var "consul_service_tags" . ]]
      tags = [[ var "consul_service_tags" . | toStringList ]]
      [[ end ]]
      port = "pgsql"
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 5432
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
      driver = "[[ var "pgsql_task.driver" . ]]"

      config {
        image   = "[[ var "pgsql_task.image" . ]]:[[ var "pgsql_task.version" . ]]"
        ports   = ["pgsql"]
      }

      env {
        [[ range $key, $var := var "env_vars" . ]]
        [[if ne (len $var) 0 ]][[ $key | upper ]] = [[ $var | quote ]][[ end ]]
        [[ end ]]
      }

      [[ template "resources" . ]]
    }
  }
}
