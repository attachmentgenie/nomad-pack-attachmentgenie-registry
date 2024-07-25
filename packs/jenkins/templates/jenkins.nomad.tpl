job [[ template "job_name" . ]] {
  [[ template "placement" . ]]

  group [[ template "job_name" . ]] {

    network {
      [[ if var "register_consul_service" . ]]
      mode = "bridge"
      [[ end ]]
      port "http" {
        to = 8080
      }
      port "jnlp" {
        to = 50000
      }
    }

    [[ if var "register_consul_service" . ]]
    service {
      name = "[[ var "consul_service_name" . ]]"
      [[ range $tag := var "consul_service_tags" . ]]
      tags = [[ var "consul_service_tags" . | toStringList ]]
      [[ end ]]
      port = "http"

      check {
        name     = "alive"
        type     = "http"
        path     = "/login"
        interval = "10s"
        timeout  = "2s"
      }
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 8080
          }
        }
      }
    }
    [[ end ]]

    [[ if var "volume_name" . ]]
    volume "[[ var "volume_name" . ]]" {
      type      = "[[ var "volume_type" . ]]"
      read_only = false
      source    = "[[ var "volume_name" . ]]"
    }
    [[- end ]]

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    [[ if var "volume_name" . ]]
    task "chown" {
      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      volume_mount {
        volume      = "[[ var "volume_name" . ]]"
        destination = "/var/jenkins_home"
        read_only   = false
      }

      driver = "docker"

      config {
        image   = "busybox:stable"
        command = "sh"
        args    = ["-c", "chown -R 1000:1000 /var/jenkins_home"]
      }

      [[ template "resources" . ]]
    }
    [[- end ]]

    [[ if var "plugins" . ]]
    task "install-plugins" {
      driver = "docker"
      [[ if var "volume_name" . ]]
      volume_mount {
        volume      = "[[ var "volume_name" . ]]"
        destination = "/var/jenkins_home"
        read_only   = false
      }
      [[- end ]]
      config {
        image   = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        command = "jenkins-plugin-cli"
        args    = ["-f", "/var/jenkins_home/plugins.txt", "--plugin-download-directory", "/var/jenkins_home/plugins/"]
        volumes = [
          "local/plugins.txt:/var/jenkins_home/plugins.txt",
        ]
      }
    
      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      template {
        data = <<EOF
[[ range $plugin := var "plugins" . ]][[ $plugin]]
[[ end ]]
EOF
        destination   = "local/plugins.txt"
        change_mode   = "noop"
      }

      [[ template "resources" . ]]
    }
    [[- end ]]

    task [[ template "job_name" . ]] {
      driver = "docker"

      [[ if var "volume_name" . ]]
      volume_mount {
        volume      = "[[ var "volume_name" . ]]"
        destination = "/var/jenkins_home"
        read_only   = false
      }
      [[- end ]]

      config {
        image = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        ports = ["http","jnlp"]
        [[ if var "jasc_config" . ]]
        volumes = [
          "local/jasc.yaml:/var/jenkins_home/jenkins.yaml",
        ]
        [[ end ]]
      }

      env {
        [[ range $key, $var := var "docker_jenkins_env_vars" . ]]
        [[if ne (len $var) 0 ]][[ $key | upper ]] = [[ $var | quote ]][[ end ]]
        [[ end ]]
      }

      [[ if var "jasc_config" . ]]
      template {
        data = <<EOF
[[ var "jasc_config" . ]]
EOF
        change_mode   = "noop"
        destination   = "local/jasc.yaml"
      }
      [[ end ]]

      [[ template "resources" . ]]

      action "show-admin-password" {
        command = "cat"
        args = ["/var/jenkins_home/secrets/initialAdminPassword"]
      }
    }
  }
}
