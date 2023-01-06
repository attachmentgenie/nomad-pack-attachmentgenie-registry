job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "registry" {
    network {
      port "http" {
        to = 5000
      }
      [[ if .my.ui_task.expose ]]
      port "ui" {
        to = 80
      }
      [[ end ]]
    }

    [[ if .my.register_consul_service ]]
    service {
      name = "[[ .my.consul_registry_service_name ]]"
      tags = [[ .my.consul_registry_service_tags | toStringList ]]
      port = "http"
      check {
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }
    
    service {
      name = "[[ .my.consul_ui_service_name ]]"
      tags = [[ .my.consul_ui_service_tags | toStringList ]]
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
      driver = "[[ .my.registry_task.driver ]]"

      config {
        image   = "[[ .my.registry_task.image ]]:[[ .my.registry_task.version ]]"
        ports = ["http"]
        volumes = [
          "local/config/registry.yaml:/etc/docker/registry/config.yml",
        ]
      }

      resources {
        cpu    = [[ .my.resources.cpu ]]
        memory = [[ .my.resources.memory ]]
      }
      

      
      template {
        data = <<EOF
[[ .my.registry_config ]]
EOF
        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/registry.yaml"
      }
    }

    [[ if .my.ui_task.expose ]]
    task "ui" {
      driver = "[[ .my.ui_task.driver ]]"

      config {
        image   = "[[ .my.ui_task.image ]]:[[ .my.ui_task.version ]]"
        ports = ["ui"]
      }
      
      env {
        [[- range $var := .my.ui_env_vars ]]
        [[ $var.key ]] = "[[ $var.value ]]"
        [[- end ]]
      }

      resources {
        cpu    = [[ .my.resources.cpu ]]
        memory = [[ .my.resources.memory ]]
      }
    }
    [[ end ]]
  }
}
