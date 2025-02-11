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
  description = "Resources used by jenkins task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 256,
    memory = 256,
  }
}

variable "register_service" {
  description = "If you want to register a service for the job"
  type        = bool
  default     = false
}

variable "service_provider" {
  description = "Specifies the service registration provider to use for service registrations."
  type        = string
  default     = "consul"
}

variable "registry_service_name" {
  description = "The service name for the registry application"
  type        = string
  default     = "registry"
}

variable "ui_service_name" {
  description = "The service name for the registry application"
  type        = string
  default     = "images"
}

variable "registry_service_tags" {
  description = "The service name for the registry application"
  type        = list(string)
  default     = []
}

variable "ui_service_tags" {
  description = "The service name for the registry application"
  type        = list(string)
  default     = []
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

variable "registry_config" {
  description = "The yaml configuration for the registry"
  type        = string
  default     = <<EOH
---
version: 0.1
http:
  addr: 0.0.0.0:5000
  headers:
    Access-Control-Allow-Origin: ['*']
storage:
  filesystem:
    rootdirectory: /var/lib/registry
EOH
}

variable "registry_task" {
  description = "Details configuration options for the registry task."
  type = object({
    driver  = string
    image   = string
    version = string
  })
  default = {
    driver  = "docker",
    image   = "registry",
    version = "latest",
  }
}

variable "env_vars" {
  description = "Environment variables to pass to Docker container."
  type        = map(string)
  default = {
    "REGISTRY_URL" : "http://$${NOMAD_HOST_ADDR_http}",
    "DELETE_IMAGES" : true,
    "SINGLE_REGISTRY" : true,
  }
}

variable "ui_task" {
  description = "Details configuration options for the ui task."
  type = object({
    driver  = string
    expose  = bool
    image   = string
    version = string
  })
  default = {
    driver  = "docker",
    expose  = true,
    image   = "joxit/docker-registry-ui",
    version = "latest",
  }
}
