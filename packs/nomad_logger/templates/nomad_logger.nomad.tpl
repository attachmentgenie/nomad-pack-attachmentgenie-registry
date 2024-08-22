job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "system"

  group "nomad-logger" {
    network {
      [[ if var "register_service" . ]]
      mode = "bridge"
      [[ end ]]
      port "metrics" {
        to = [[ var "metrics_exporter_port" . ]]
      }
    }

    [[ if var "register_service" . ]]
    service {
      name     = "[[ var "service_name" . ]]"
      provider = "[[ var "service_provider" . ]]"
      [[ range $tag := var "service_tags" . ]]
      tags     = [[ var "service_tags" . | toStringList ]]
      [[ end ]]
      port     = "metrics"
      check {
        name     = "alive"
        type     = "http"
        path     = "/metrics"
        interval = "10s"
        timeout  = "2s"
      }
    }
    [[ end ]]

    restart {
      interval = "5m"
      attempts = 10
      delay    = "30s"
      mode     = "delay"
    }

    [[ template "volume" . ]]

    task "nomad-logger" {
      driver = "docker"
      config {
        image = "[[ var "task.image" . ]]:[[ var "task.version" . ]]"
        ports = ["metrics"]
      }

      [[ template "env_upper" . ]]

      [[ if var "volume_name" . ]]
      volume_mount {
        volume = "promtail-configs"
        destination = "/target"
        read_only = false
      }
      [[- end ]]

      [[ template "resources" . ]]
    }
  }
}
