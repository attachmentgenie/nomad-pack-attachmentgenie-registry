// Generic env_vars template
[[- define "env_vars" -]]
      [[- $task_config := var "task_config" . ]]
      [[- if $task_config.env_vars ]]
      [[- if gt (len $task_config.env_vars) 0 ]]
      env {
        [[- range $key, $value := $task_config.env_vars ]]
        [[ $key ]] = [[ $value | quote ]]
        [[- end ]]
      }
      [[- end -]]
      [[- end -]]
[[- end -]]

// Inject your own config
[[ define "template_config_toml" -]]
[[- if var "task_config.nomad_events_sink_toml" . ]]
      template {
        data = <<EOH
[[ var "task_config.nomad_events_sink_toml" . ]]
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/nomad-events-sink.toml"
      }
[[- end ]]
[[- end ]]
