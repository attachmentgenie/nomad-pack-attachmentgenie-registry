# Valkey -- Standalone Instance

This pack runs [Valkey](https://valkey.io) as a standalone instance using the Nomad [service](https://www.nomadproject.io/docs/schedulers#service) scheduler. The service runs as a Docker container using the [Docker](https://www.nomadproject.io/docs/drivers/docker) driver.

This is a standalone instance of Valkey.

---
## Available Variables
`app_count` (number) - Number of instances to deploy
`service_name` (string) - Name used by Consul, if registering the job in Consul
`service_port` (string) - Port used by Consul, if registering the job in Consul
`consul_tags` (list of string) - Tags to use for job
`datacenters` (list of string) - Datacenters this job will be deployed
`has_health_check` (bool) - If Consul should use a health check -- Port needs to be exposed.
`health_check` (object) - Consul health check details
`region` (string) - Region where the job should be placed.
`register_service` (bool) - Register this job in Consul
`task_resources` (object) - Resources to assign this job
`restart_attempts` (number) - Number of attempts to restart the job due to updates, failures, etc
`update` (object) - Job update parameters
