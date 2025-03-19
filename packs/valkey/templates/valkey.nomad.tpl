job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "valkey" {
    count = [[ var "app_count" . ]]

    network {
      [[ if var "register_service" . ]]
      [[  $service_provider := var "service_provider" . ]]
      [[ if eq $service_provider "consul" ]]
      mode = "bridge"
      [[ end ]]
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

    [[- if var "register_service" . ]]
    service {
      name     = [[ var "service_name" . | quote ]]
      port     = "db"
      provider = "[[ var "service_provider" . ]]"
      tags     = [[ var "consul_tags" . | toStringList ]]
      [[- if .my.has_health_check ]]
      check {
        name     = "valkey"
        type     = "tcp"
        port     = [[ var "health_check.port" . ]]
        interval = [[ var "health_check.interval" . | quote ]]
        timeout  = [[ var "health_check.timeout" . | quote ]]
      }
      [[- end ]]
      [[ if var "service_connect_enabled" . ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = [[ var "service_port" . | quote ]]
          }
        }
      }
      [[ end ]]
    }
    [[- end ]]

    restart {
      attempts = [[ var "restart_attempts" . ]]
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    [[ template "volume" . ]]

    task "valkey" {
      driver = "[[ var "task.driver" . ]]"

      config {
        image   = "[[ var "task.image" . ]]:[[ var "task.version" . ]]"
      }

      [[ template "resources" . ]]

      [[ if var "volume_name" . ]]
      volume_mount {
        volume      = "valkey"
        destination = "/data"
        read_only   = false
      }
      [[- end ]]
    }
  }
}
