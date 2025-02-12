job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "minio" {
    count = [[ var "app_count" . ]]

    network {
      [[ if var "register_service" . ]]
      [[  $service_provider := var "service_provider" . ]]
      [[ if eq $service_provider "consul" ]]
      mode = "bridge"
      [[ end ]]
      [[ end ]]
      port "s3" {
        to = 9000
      }
      port "console" {
        to = 9001
      }
    }

    [[ if var "register_service" . ]]
    service {
      name     = "[[ var "service_name" . ]]"
      provider = "[[ var "service_provider" . ]]"
      [[ range $tag := var "service_tags" . ]]
      tags     = [[ var "service_tags" . | toStringList ]]
      [[ end ]]
      port     = "s3"
      check {
        name     = "alive"
        type     = "http"
        path     = "/minio/health/live"
        interval = "10s"
        timeout  = "2s"
      }
      [[ if var "service_connect_enabled" . ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 9000
          }
        }
      }
      [[ end ]]
    }
    [[ end ]]

    [[ template "volume" . ]]

    task "server" {
      driver = "[[ var "task.driver" . ]]"

      config {
        image = "[[ var "task.image" . ]]:[[ var "task.version" . ]]"
        ports = ["s3","console"]
        args  = [
          "server",
          "/data",
          "--console-address",
          ":9001"
        ]
      }

      [[ template "env_upper" . ]]

      [[ template "resources" . ]]

      [[ if var "volume_name" . ]]
      volume_mount {
        volume      = "minio"
        destination = "/data"
        read_only   = false
      }
      [[- end ]]
    }
  }
}
