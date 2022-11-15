count = 3
env_vars = [
    {key = "POSTGRES_PASSWORD", value = "mysecretpassword"},
    {key = "PATRONI_NAME", value = "member_1"},
    {key = "PATRONI_POSTGRESQL_DATA_DIR", value = "/var/lib/postgresql/data/node1"},
    {key = "PATRONI_CONSUL_HOST", value = "http://192.168.1.10:8500"},
    {key = "PATRONI_CONSUL_REGISTER_SERVICE", value = true}
  ]
pgsql_task = {
  driver  = "docker",
  image   = "timescale/timescaledb-ha",
  version = "pg14-latest",
}
use_patroni = true