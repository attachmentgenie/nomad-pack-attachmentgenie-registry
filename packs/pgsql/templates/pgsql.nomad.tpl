job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "pgsql" {
    count = [[ .my.count ]]

    network {
      port "pgsql" {
        to = 5432
      }
      [[ if .my.use_patroni ]]
      port "patroni" {
        to = 8008
      }
      port "pgbackrest" {
        to = 8081
      }
      [[ end ]]
    }

    [[ if .my.register_consul_service ]]
    service {
      name = "[[ .my.consul_service_name ]]"
      tags = [[ .my.consul_service_tags | toStringList ]]
      check {
        name     = "alive"
        type     = "tcp"
        port     = "pgsql"
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
      driver = "[[ .my.pgsql_task.driver ]]"

      config {
        image = "[[ .my.pgsql_task.image ]]:[[ .my.pgsql_task.version ]]"
        ports = ["pgsql"]
      }

      env {
        [[- range $var := .my.env_vars ]]
        [[ $var.key ]] = "[[ $var.value ]]"
        [[- end ]]
      }

      resources {
        cpu    = [[ .my.resources.cpu ]]
        memory = [[ .my.resources.memory ]]
      }
    }
  }
}
