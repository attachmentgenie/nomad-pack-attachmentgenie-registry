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

variable "app_count" {
  description = "Number of instances to deploy"
  type        = number
  default     = 1
}

// Redis Group-Level Variables
variable "update" {
  description = "Job update parameters"
  type        = object({
    min_healthy_time  = string
    healthy_deadline  = string
    progress_deadline = string
    auto_revert       = bool
  })
  default     = {
    min_healthy_time  = "10s",
    healthy_deadline  = "5m",
    progress_deadline = "10m",
    auto_revert       = true,
  }
}

variable "use_host_volume" {
  description = "Use a host volume as defined in the Nomad client configuration"
  type        = bool
  default     = false
}

variable "redis_volume" {
  description = "The volume name defined in the Nomad agent configuration"
  type        = string
  default     = "redis"
}

variable "register_consul_service" {
  description = "Register this job in Consul"
  type        = bool
  default     = true
}

variable "consul_service_name" {
  description = "Name used by Consul, if registering the job in Consul"
  type        = string
  default     = "redis"
}

variable "consul_service_port" {
  description = "Port used by Consul, if registering the job in Consul"
  type        = string
  default     = "6379"
}

variable "consul_tags" {
  description = "Tags to use for job"
  type        = list(string)
  default     = [
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

// Redis Task-Level Variables
variable "image" {
  description = "Redis Docker image."
  type        = string
  default     = "redis:latest"
}

variable "resources" {
  description = "Resources to assign this job"
  type        = object({
    cpu    = number
    memory = number
  })
  default     = {
    cpu    = 500,
    memory = 500
  }
}
