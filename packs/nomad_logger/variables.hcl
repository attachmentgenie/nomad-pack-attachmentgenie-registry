variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name"
  type        = string
  // If "", the pack name will be used
  default = ""
}

variable "region" {
  description = "The region where jobs will be deployed"
  type        = string
  default     = ""
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement"
  type        = list(string)
  default     = ["*"]
}

variable "namespace" {
  description = "The namespace where the job should be placed."
  type        = string
  default     = "default"
}

variable "node_pool" {
  description = "The node_pool where the job should be placed."
  type        = string
  default     = "all"
}

variable "priority" {
  description = "The priority value the job will be given"
  type        = number
  default     = 100
}

variable "task_constraints" {
  description = "Constraints to apply to the entire job."
  type = list(object({
    attribute = string
    operator  = string
    value     = string
  }))
  default = [
    {
      attribute = "$${attr.kernel.name}",
      value     = "(linux|darwin)",
      operator  = "regexp",
    },
  ]
}

variable "task_resources" {
  description = "The resources to assign to the OpenTelemetry Collector task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 100
    memory = 25
  }
}

variable "metrics_exporter_port" {
  description = "The Nomad client port that routes to metrics endpoint."
  type        = number
  default     = 2112
}

variable "register_consul_service" {
  description = "If you want to register a consul service for the job"
  type        = bool
  default     = true
}

variable "consul_service_name" {
  description = "The consul service name for the nomad logger application"
  type        = string
  default     = "nomad-logger"
}

variable "task" {
  description = "Options for the task"
  type = object({
    image   = string
    version = string
  })
  default = {
    image   = "attachmentgenie/nomad-logger"
    version = "latest"
  }
}

variable "task_service_tags" {
  description = "The consul service name for the nomad logger application"
  type        = list(string)
  default     = []
}

variable "volume_name" {
  description = "The name of the volume you want Jenkins to use."
  type        = string
  default     = "promtail-configs"
}

variable "volume_type" {
  description = "The type of the volume you want Jenkins to use."
  type        = string
  default     = "host"
}

variable "env_vars" {
  type        = map(string)
  description = "Environment variables to pass to Docker container."
  default     = {
    "NOMAD_ADDR" : "http://$${attr.nomad.advertise.address}",
  }
}
