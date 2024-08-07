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

    [[ if var "register_consul_service" . ]]
    service {
      name = "[[ var "consul_registry_service_name" . ]]"
      tags = [[ var "consul_registry_service_tags" . | toStringList ]]
      port = "http"
      check {
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }
    
    service {
      name = "[[ var "consul_ui_service_name" . ]]"
      tags = [[ var "consul_ui_service_tags" . | toStringList ]]
      port = "ui"
      check {
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

      env {
        REGISTRY_URL = "http://${NOMAD_HOST_ADDR_http}"
        [[ range $key, $var := var "ui_env_vars" . ]]
        [[if ne (len $var) 0 ]][[ $key | upper ]] = [[ $var | quote ]][[ end ]]
        [[ end ]]
      }

      [[ template "resources" . ]]
    }
    [[ end ]]
  }
}
