job [[ template "job_name" . ]] {
  [[ template "placement" . ]]

  group "registry" {
    network {
      port "http" {
        to = 5000
      }
      [[ if var "ui_task.expose" . ]]
      port "ui" {
        to = 80
      }
      [[ end ]]
    }

    [[ if var "register_service" . ]]
    service {
      name     = "[[ var "registry_service_name" . ]]"
      provider = "[[ var "service_provider" . ]]"
      tags     = [[ var "registry_service_tags" . | toStringList ]]
      port     = "http"
      check {
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }
    
    service {
      name     = "[[ var "ui_service_name" . ]]"
      provider = "[[ var "service_provider" . ]]"
      tags     = [[ var "ui_service_tags" . | toStringList ]]
      port     = "ui"
      check {
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }
    [[ end ]]

    [[ template "volume" . ]]

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "store" {
      driver = "[[ var "registry_task.driver" . ]]"

      config {
        image   = "[[ var "registry_task.image" . ]]:[[ var "registry_task.version" . ]]"
        ports = ["http"]
        volumes = [
          "local/config/registry.yaml:/etc/docker/registry/config.yml",
        ]
      }

      [[ template "resources" . ]]

      [[ if var "volume_name" . ]]
      volume_mount {
        volume      = "[[ var "volume_name" . ]]"
        destination = "/var/lib/registry"
        read_only   = false
      }
      [[- end ]]

      template {
        data = <<EOF
[[ var "registry_config" . ]]
EOF
        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/registry.yaml"
      }
    }

    [[ if var "ui_task.expose" . ]]
    task "ui" {
      driver = "[[ var "ui_task.driver" . ]]"

      config {
        image   = "[[ var "ui_task.image" . ]]:[[ var "ui_task.version" . ]]"
        ports = ["ui"]
      }

      [[ template "env_upper" . ]]

      [[ template "resources" . ]]
    }
    [[ end ]]
  }
}
