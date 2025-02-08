job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  group "autoscaler" {
    count = [[ var "app_count" . ]]

    network {
      [[- if var "autoscaler_agent_task_service.enabled" . ]]
      mode = "bridge"
      [[ end ]]
      port "http" {
        to = 8080
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
      [[ if var "service_connect_enabled" . ]]

      check {
        type     = "http"
        path     = "/v1/health"
        interval = "3s"
        timeout  = "1s"
      }

      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 8080
            [[ range $upstream := var "service_upstreams" . ]]
            upstreams {
              destination_name = [[ $upstream.name | quote ]]
              local_bind_port  = [[ $upstream.port ]]
            }
            [[ end ]]
          }
        }
      }
      [[ end ]]
    }
    [[- end ]]

    task "autoscaler_agent" {
      driver = "[[ var "task.driver" . ]]"

      config {
        image   = "[[ var "task.image" . ]]:[[ var "task.version" . ]]"
        command = "nomad-autoscaler"
        ports   = ["http"]
        args    = [[ template "full_args" . ]]
      }

      [[ template "artifacts" . ]]

      [[- if var "task.config_files" . ]]
      [[ range $idx, $file := var "task.config_files" . ]]
      template {
        data = <<EOF
[[ fileContents $file ]]
        EOF

        destination = [[ printf "\"${NOMAD_TASK_DIR}/config/%s\"" ( base $file ) ]]
      }
      [[ end ]]
      [[- end ]]

      [[- if var "task.scaling_policy_files" . -]]
      [[ range $idx, $file := var "task.scaling_policy_files" . ]]
      template {
        data = <<EOF
[[ fileContents $file ]]
        EOF

        destination = [[ printf "\"${NOMAD_TASK_DIR}/policies/%s\"" ( base $file ) ]]
      }
      [[ end ]]
      [[- end ]]

      [[ template "resources" . ]]
    }
  }
}
