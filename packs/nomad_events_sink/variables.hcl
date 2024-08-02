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
  default     = "default"
}

variable "priority" {
  description = "The priority value the job will be given"
  type        = number
  default     = 80
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
    cpu    = 256,
    memory = 512,
  }
}

variable "task_config" {
  description = "Options for the task"
  type = object({
    env_vars               = map(string)
    image                  = string
    nomad_events_sink_toml = string
    version                = string
  })
  default = {
    env_vars = {
      NOMAD_EVENTS_SINK_app__data_dir = "/alloc/data/"
      NOMAD_ADDR                      = "http://$${attr.nomad.advertise.address}"
    }
    image                  = "ghcr.io/attachmentgenie/nomad-events-sink"
    nomad_events_sink_toml = ""
    version                = "latest"
  }
}
