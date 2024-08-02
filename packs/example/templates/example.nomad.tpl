job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group [[ template "job_name" . ]] {

    network {
      [[ if var "register_consul_service" . ]]
      mode = "bridge"
      [[ end ]]
      port "http" {
        to = 8088
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
        path     = "/health"
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
