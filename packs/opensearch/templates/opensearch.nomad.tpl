job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "opensearch" {
    count = [[ var "app_count" . ]]

    network {
      [[ if var "register_consul_service" . ]]
      mode = "bridge"
      [[ end ]]
      port "http" {
        to = 9200
      }
      port "performance" {
        to = 9600
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
        type     = "http"
        protocol = "https"
        path     = "_cluster/health"
        interval = "10s"
        timeout  = "2s"
        tls_skip_verify = true
        header {
          Authorization = ["Basic YWRtaW46YWRtaW4="] # admin:admin
        }
      }
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 9200
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
        image   = "[[ var "task.image" . ]]:[[ var "task.version" . ]]"
        ports   = ["http","performance"]
      }

      env = {
        [[ range $key, $var := var "env_vars" . ]]
        [[if ne (len $var) 0 ]][[ $key | quote ]] = [[ $var | quote ]][[ end ]]
        [[ end ]]
      }

      [[ template "resources" . ]]
    }
  }
}
