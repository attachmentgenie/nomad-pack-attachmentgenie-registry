job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "redis" {
    count = [[ var "app_count" . ]]

    network {
      [[ if var "register_consul_service" . ]]
      mode = "bridge"
      [[ end ]]
      port "db" {
        to = 6379
      }
    }

    update {
      min_healthy_time  = [[ var "update.min_healthy_time" . | quote ]]
      healthy_deadline  = [[ var "update.healthy_deadline" . | quote ]]
      progress_deadline = [[ var "update.progress_deadline" . | quote ]]
      auto_revert       = [[ var "update.auto_revert" . ]]
    }

    [[- if var "register_consul_service" . ]]
    service {
      name = [[ var "consul_service_name" . | quote ]]
      port = "db"
      tags = [[ var "consul_tags" . | toStringList ]]

      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = [[ var "consul_service_port" . | quote ]]
          }
        }
      }

      [[- if .my.has_health_check ]]
      check {
        name     = "redis"
        type     = "tcp"
        port     = [[ var "health_check.port" . ]]
        interval = [[ var "health_check.interval" . | quote ]]
        timeout  = [[ var "health_check.timeout" . | quote ]]
      }
      [[- end ]]
    }
    [[- end ]]

    restart {
      attempts = [[ var "restart_attempts" . ]]
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    [[ template "volume" . ]]

    task "redis" {
      driver = "docker"

      config {
        image = [[ var "image" . | quote ]]
      }

      [[ template "resources" . ]]

      [[ if var "volume_name" . ]]
      volume_mount {
        volume      = "redis"
        destination = "/data"
        read_only   = false
      }
      [[- end ]]
    }
  }
}
