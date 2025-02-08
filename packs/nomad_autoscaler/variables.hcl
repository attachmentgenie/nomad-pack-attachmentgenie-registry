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

variable "task_artifacts" {
  description = "Define external artifacts for the autoscaler."
  type = list(object({
    source      = string
    destination = string
    mode        = string
    options     = map(string)
  }))
  default = []
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

variable "task" {
  description = "Details configuration options for the Nomad Autoscaler agent task."
  type = object({
    driver               = string
    version              = string
    additional_cli_args  = list(string)
    config_files         = list(string)
    scaling_policy_files = list(string)
  })
  default = {
    driver               = "docker",
    image                = "hashicorp/nomad-autoscaler",
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

variable "app_count" {
  description = "Number of instances to deploy"
  type        = number
  default     = 3
}

variable "register_service" {
  description = "If you want to register a service for the job"
  type        = bool
  default     = false
}

variable "service_connect_enabled" {
  description = "If this service will announce itself to the service mesh. Only valid is 'service_provider == 'consul' "
  type        = bool
  default     = false
}

variable "service_name" {
  description = "The service name for the application."
  type        = string
  default     = "nomad-autoscaler"
}

variable "service_provider" {
  description = "Specifies the service registration provider to use for service registrations."
  type        = string
  default     = "consul"
}

variable "service_tags" {
  description = "The service name for the application."
  type        = list(string)
  default     = []
}

variable "service_upstreams" {
  description = ""
  type = list(object({
    name = string
    port = number
  }))
}
