job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "nomad_events_sink" {
    ephemeral_disk {
      migrate = true
      size    = 200
      sticky  = true
    }
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    task [[ template "job_name" . ]] {
      driver = "docker"
      config {
        image = "[[ var "task_config.image" . ]]:[[ var "task_config.version" . ]]"
        [[- if var "task_config.nomad_events_sink_toml" . ]]
        volumes = [
          "local/config:/config",
        ]
        [[- end ]]
      }
      [[ template "template_config_toml" . ]]
      [[ template "env_upper" . ]]

      [[ template "resources" . ]]
    }
  }
}
