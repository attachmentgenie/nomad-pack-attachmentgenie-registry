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
