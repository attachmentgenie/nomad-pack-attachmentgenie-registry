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
  description = "The consul service name for the mysql application"
  type        = string
  default     = "mysql"
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
    {key = "MYSQL_ROOT_PASSWORD", value = "mysecretpassword"},
  ]
}

variable "resources" {
  description = "The resource to assign to the tempo service task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 200,
    memory = 512
  }
}

variable "version_tag" {
  description = "The docker image version. For options, see https://hub.docker.com/_/mysql"
  type        = string
  default     = "latest"
}
