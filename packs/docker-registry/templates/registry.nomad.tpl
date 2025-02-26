job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group [[ template "job_name" . ]] {

    network {
      [[ if var "register_service" . ]]
      [[  $service_provider := var "service_provider" . ]]
      [[ if eq $service_provider "consul" ]]
      mode = "bridge"
      [[ end ]]
      [[ end ]]
      port "http" {
        to = 5000
      }
    }

    [[ if var "register_service" . ]]
    service {
      name     = "[[ var "service_name" . ]]"
      provider = "[[ var "service_provider" . ]]"
      [[ range $tag := var "service_tags" . ]]
      tags     = [[ var "service_tags" . | toStringList ]]
      [[ end ]]
      port     = "http"
      check {
        name     = "alive"
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

    task "server" {
      driver = "[[ var "task.driver" . ]]"

      config {
        image   = "[[ var "task.image" . ]]:[[ var "task.version" . ]]"
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
[[ var "config" . ]]
EOF
        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/registry.yaml"
      }
    }
  }
}
