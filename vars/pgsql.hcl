datacenters = [
  "lab",
]
count = 3
pgsql_task = {
  driver  = "docker",
  image   = "timescale/timescaledb-ha",
  version = "pg14-latest",
}
use_patroni = true