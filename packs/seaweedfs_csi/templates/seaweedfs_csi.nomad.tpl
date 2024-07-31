job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "system"
  group "nodes" {
    task "plugin" {
      driver = "docker"
      config {
        image        = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
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
