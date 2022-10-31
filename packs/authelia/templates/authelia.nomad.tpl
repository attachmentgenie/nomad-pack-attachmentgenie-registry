job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "authelia" {
    count = [[ .my.count ]]

    network {
      mode = "bridge"
      port "http" {
        to = 9091
      }
    }

    [[ if .my.register_consul_service ]]
    service {
      name = "[[ .my.consul_service_name ]]"
      tags = [[ .my.consul_service_tags | toStringList ]]
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
      driver = "docker"

      config {
        image = "authelia/authelia:latest"
        ports = ["http"]
        volumes = [
          "local/config:/config",
        ]
      }

      [[- if ne .my.authelia_task_app_configuration_yaml "" ]]
      template {
        data = <<EOH
[[ .my.authelia_task_app_configuration_yaml ]]
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/configuration.yml"
      }
      [[- end ]]

      [[- if ne .my.authelia_task_app_users_database_yaml "" ]]
      template {
        data = <<EOH
[[ .my.authelia_task_app_users_database_yaml ]]
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/users_database.yml"
      }
      [[- end ]]
    }
  }
}
