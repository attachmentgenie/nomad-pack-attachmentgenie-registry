job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  type = "service"

  group "app" {
    count = [[ var "app_count" . ]]

    network {
      port "http" {
        to = 8000
      }
    }

    [[ if var "register_service" . ]]
    service {
      name = "[[ var "service_name" . ]]"
      tags = [[ var "service_tags" . | toStringList ]]
      provider = "nomad"
      port = "http"
      check {
        name     = "alive"
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

    task "server" {
      driver = "[[ var "task.driver" . ]]"

      config {
        image   = "[[ var "task.image" . ]]:[[ var "task.version" . ]]"
        ports = ["http"]
      }
    }
  }
}
