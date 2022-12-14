variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name"
  type        = string
  // If "", the pack name will be used
  default = ""
}

variable "namespace" {
  description = "The namespace where jobs will be deployed"
  type        = string
  default     = ""
}

variable "region" {
  description = "The region where jobs will be deployed"
  type        = string
  default     = ""
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement"
  type        = list(string)
  default     = ["dc1"]
}

variable "count" {
  description = "The number of app instances to deploy"
  type        = number
  default     = 1
}

variable "register_consul_service" {
  description = "If you want to register a consul service for the job"
  type        = bool
  default     = true
}

variable "consul_service_name" {
  description = "The consul service name for the pgsql application"
  type        = string
  default     = "pgsql"
}

variable "consul_service_tags" {
  description = "The consul service name for the pgsql application"
  type        = list(string)
  default = []
}

variable "env_vars" {
  description = "env vars to inject"
  type = list(object({
    key   = string
    value = string
  }))
  default = [
    {key = "POSTGRES_PASSWORD", value = "mysecretpassword"},
  ]
}

variable "resources" {
  description = "The resource to assign to the pgsql service task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 200,
    memory = 256
  }
}

variable "pgsql_task" {
  description = "Details configuration options for the promlens task."
  type        = object({
    driver  = string
    image   = string
    version = string
  })
  default = {
    driver  = "docker",
    image   = "postgres",
    version = "latest",
  }
}

variable "use_patroni" {
  description = "If you want to use patroni to build a cluster"
  type        = bool
  default     = false
}

variable "patroni_yaml" {
  description = "The patroni configuration to pass to the task."
  type        = string
  default     = ""
}