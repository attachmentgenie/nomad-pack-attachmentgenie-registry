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
        type     = "http"
        port     = "patroni"
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
      driver = "[[ .my.pgsql_task.driver ]]"

      config {
        image   = "[[ .my.pgsql_task.image ]]:[[ .my.pgsql_task.version ]]"
        ports   = ["pgsql","patroni","pgbackrest"]
        [[ if .my.use_patroni ]]
        command = "/patroni_entrypoint.sh"
        volumes = [
          "local/config/postgres.yml:/home/postgres/postgres.yml",
        ]
        [[- end ]]
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
      
      [[ if .my.use_patroni ]]
      template {
        data = <<EOH
scope: patroni_cluster
name: server-1
namespace: /patroni/

restapi:
  listen: 0.0.0.0:8008 # node's IP and port where Patroni API will operate
  connect_address: 0.0.0.0:8008 
  authentication:
    username: patroni
    password: 'mysuperpassword'

raft:
  self_addr: 0.0.0.0:8009

bootstrap:
  dcs:
    ttl: 30
    loop_wait: 10
    retry_timeout: 10
    maximum_lag_on_failover: 1048576
    synchronous_mode: false
    postgresql:
      use_pg_rewind: true
      use_slots: true
      parameters:
        wal_level: hot_standby
        synchronous_commit: off
        hot_standby: "on"

  initdb:
  - encoding: UTF8
  - data-checksums

  pg_hba:
  - local all postgres trust
  - host postgres all 127.0.0.1/32 md5
  - host replication replicator 0.0.0.0/0 md5
  - host replication all 192.168.0.16/32 trust # server-1
  - host replication all 192.168.0.9/32 trust  # server-2
  - host replication all 192.168.0.12/32 trust # server-3
  - host all all 0.0.0.0/0 md5

  users:
    admin:
      password: 'mysuperpassword2'
      options:
        - createrole
        - createdb

postgresql:
  listen: 192.168.0.16:5432 # interface's IP and port where PostgreSQL will listen
  connect_address: 192.168.0.16:5432 
  data_dir: /data/patroni
  bin_dir: /usr/lib/postgresql/11/bin
  config_dir: /data/patroni
  pgpass: /tmp/pgpass0
  authentication:
    replication:
      username: replicator
      password: 'mysuperpassword3'
    superuser:
      username: postgres
      password: 'mysuperpassword4'
    rewind:
      username: rewind_user
      password: 'mysuperpassword5'
  parameters:
    unix_socket_directories: '/tmp'

tags:
    nofailover: false
    noloadbalance: false
    clonefrom: false
    nosync: false
EOH
        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/postgres.yml"
      }
      [[- end ]]
    }
  }
}
