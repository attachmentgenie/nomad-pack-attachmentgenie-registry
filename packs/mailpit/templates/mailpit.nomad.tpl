job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "app" {
    network {
      port "http" {
        to = 8025
      }
      port "smtp" {
        to = 1025
      }
    }

    [[ if var "register_consul_service" . ]]
    service {
      name = "[[ var "consul_service_name" . ]]"
      [[ range $tag := var "consul_service_tags" . ]]
      tags = [[ var "consul_service_tags" . | toStringList ]]
      [[ end ]]
      port = "http"
      check {
        name     = "alive"
        type     = "http"
        path     = "/"
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
      driver = "[[ var "task.driver" . ]]"

      config {
        image   = "[[ var "task.image" . ]]:[[ var "task.version" . ]]"
        ports   = ["http","smtp"]
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
