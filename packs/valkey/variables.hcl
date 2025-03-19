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
  default     = 50
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
    cpu    = 256
    memory = 512
  }
}

variable "app_count" {
  description = "Number of instances to deploy"
  type        = number
  default     = 1
}

// Valkey Group-Level Variables
variable "update" {
  description = "Job update parameters"
  type = object({
    min_healthy_time  = string
    healthy_deadline  = string
    progress_deadline = string
    auto_revert       = bool
  })
  default = {
    min_healthy_time  = "10s",
    healthy_deadline  = "5m",
    progress_deadline = "10m",
    auto_revert       = true,
  }
}

variable "register_service" {
  description = "Register this job in Consul"
  type        = bool
  default     = false
}

variable "service_connect_enabled" {
  description = "If this service will announce itself to the service mesh. Only valid is 'service_provider == 'consul' "
  type        = bool
  default     = false
}

variable "service_name" {
  description = "Name used by Consul, if registering the job in Consul"
  type        = string
  default     = "valkey"
}

variable "service_port" {
  description = "Port used by Consul, if registering the job in Consul"
  type        = string
  default     = "6379"
}

variable "service_provider" {
  description = "Specifies the service registration provider to use for service registrations."
  type        = string
  default     = "consul"
}

variable "consul_tags" {
  description = "Tags to use for job"
  type        = list(string)
  default = [
    "database"
  ]
}

variable "has_health_check" {
  description = "If Consul should use a health check -- Port needs to be exposed."
  type        = bool
  default     = false
}

variable "health_check" {
  description = "Consul health check details"
  type = object({
    port     = number
    interval = string
    timeout  = string
  })
  default = {
    port     = "6379"
    interval = "10s"
    timeout  = "2s"
  }
}

variable "restart_attempts" {
  description = "Number of attempts to restart the job due to updates, failures, etc"
  type        = number
  default     = 2
}

variable "task" {
  description = "Details configuration options for the valkey task."
  type = object({
    driver  = string
    image   = string
    version = string
  })
  default = {
    driver  = "docker",
    image   = "valkey/valkey",
    version = "latest",
  }
}

variable "volume_access_mode" {
  description = "Defines whether a volume should be available concurrently."
  type        = string
  default     = "multi-node-multi-writer"
}

variable "volume_attachment_mode" {
  description = "The storage API that will be used by the volume."
  type        = string
  default     = "file-system"
}

variable "volume_name" {
  description = "The name of the volume you want Jenkins to use."
  type        = string
}

variable "volume_type" {
  description = "The type of the volume you want Jenkins to use."
  type        = string
  default     = "host"
}
