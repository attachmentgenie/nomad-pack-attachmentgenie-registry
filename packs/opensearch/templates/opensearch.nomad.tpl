job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "opensearch" {
    count = [[ .my.count ]]

    network {
      mode = "bridge"
      port "http" {
        to = 9200
      }
      port "performance" {
        to = 9600
      }
    }

    [[ if .my.register_consul_service ]]
    service {
      name = "[[ .my.consul_service_name ]]"
      tags = [[ .my.consul_service_tags | toStringList ]]
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
      driver = "[[ .my.task.driver ]]"

      config {
        image   = "[[ .my.task.image ]]:[[ .my.task.version ]]"
        ports   = ["http","performance"]
      }

      env = {
        [[- range $var := .my.env_vars ]]
        "[[ $var.key ]]" = "[[ $var.value ]]"
        [[- end ]]
      }

      resources {
        cpu    = [[ .my.resources.cpu ]]
        memory = [[ .my.resources.memory ]]
      }
    }
  }
}
