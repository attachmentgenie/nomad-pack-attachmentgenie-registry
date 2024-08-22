variable "job_name" {
  # If "", the pack name will be used
  description = "The name to use as the job name which overrides using the pack name"
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
      value     = "linux",
      operator  = "",
    },
  ]
}

variable "autoscaler_agent_network" {
  description = "The Nomad Autoscaler network configuration options."
  type = object({
    autoscaler_http_port_label = string
  })
  default = {
    autoscaler_http_port_label = "http",
  }
}

variable "autoscaler_agent_task" {
  description = "Details configuration options for the Nomad Autoscaler agent task."
  type = object({
    count                = number
    driver               = string
    version              = string
    additional_cli_args  = list(string)
    config_files         = list(string)
    scaling_policy_files = list(string)
  })
  default = {
    count                = 3,
    driver               = "docker",
    version              = "latest",
    additional_cli_args  = ["-nomad-address=http://$${attr.unique.network.ip-address}:4646", "-http-bind-address=0.0.0.0", "-high-availability-enabled"],
    config_files         = [],
    scaling_policy_files = []
  }
}

variable "task_resources" {
  description = "The resources to assign to the OpenTelemetry Collector task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 256
    memory = 512
  }
}

variable "autoscaler_agent_task_service" {
  description = "Configuration options of the Nomad Autoscaler service and check."
  type = object({
    connect_enabled  = bool
    enabled          = bool
    service_name     = string
    service_provider = string
    service_tags     = list(string)
    check_interval   = string
    check_timeout    = string
  })
  default = {
    connect_enabled  = false
    enabled          = false
    service_name     = "nomad-autoscaler",
    service_provider = consul,
    service_tags     = [],
    check_interval   = "3s",
    check_timeout    = "1s",
  }
}

variable "autoscaler_agent_task_upstreams" {
  description = ""
  type = list(object({
    name = string
    port = number
  }))
}