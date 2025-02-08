job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "system"
  group "nodes" {
    task "plugin" {
      driver = "[[ var "task.driver" . ]]"
      config {
        image        = "[[ var "task.image" . ]]:[[ var "task.version" . ]]"
        network_mode = "host"
        args         = [[ var "cli_args" . | toPrettyJson ]]
        privileged   = true
      }

      csi_plugin {
        id        = "seaweedfs"
        type      = "monolith"
        mount_dir = "/csi"
      }

      [[ template "resources" . ]]
    }
  }
}
