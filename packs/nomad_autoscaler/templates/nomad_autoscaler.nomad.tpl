job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  group "autoscaler" {
    count = [[ var "autoscaler_agent_task.count" . ]]

    network {
      [[- if var "autoscaler_agent_task_service.enabled" . ]]
      mode = "bridge"
      [[ end ]]
      port [[ var "autoscaler_agent_network.autoscaler_http_port_label" . | quote ]] {
        to = 8080
      }
    }

    [[- if var "autoscaler_agent_task_service.enabled" . ]]
    service {
      name     = [[ var "autoscaler_agent_task_service.service_name" . | quote ]]
      port     = [[ var "autoscaler_agent_network.autoscaler_http_port_label" . | quote ]]
      provider = [[ var "autoscaler_agent_task_service.service_provider" . | quote ]]
      tags     = [[ var "autoscaler_agent_task_service.service_tags" . | toStringList ]]

      check {
        type     = [[ var "autoscaler_agent_network.autoscaler_http_port_label" . | quote ]]
        path     = "/v1/health"
        interval = [[ var "autoscaler_agent_task_service.check_interval" . | quote ]]
        timeout  = [[ var "autoscaler_agent_task_service.check_timeout" . | quote ]]
      }

      [[- if var "autoscaler_agent_task_service.connect_enabled" . ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 8080
            [[ range $upstream := var "autoscaler_agent_task_upstreams" . ]]
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
      driver = [[ var "autoscaler_agent_task.driver" . | quote ]]

      config {
        image   = "hashicorp/nomad-autoscaler:[[ var "autoscaler_agent_task.version" . ]]"
        command = "nomad-autoscaler"
        ports   = [ [[ var "autoscaler_agent_network.autoscaler_http_port_label" . | quote ]] ]
        args    = [[ template "full_args" . ]]
      }

      [[- if var "autoscaler_agent_task.config_files" . ]]
      [[ range $idx, $file := var "autoscaler_agent_task.config_files" . ]]
      template {
        data = <<EOF
[[ fileContents $file ]]
        EOF

        destination = [[ printf "\"${NOMAD_TASK_DIR}/config/%s\"" ( base $file ) ]]
      }
      [[ end ]]
      [[- end ]]

      [[- if var "autoscaler_agent_task.scaling_policy_files" . -]]
      [[ range $idx, $file := var "autoscaler_agent_task.scaling_policy_files" . ]]
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
