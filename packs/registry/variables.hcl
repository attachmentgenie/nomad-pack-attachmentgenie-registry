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

variable "register_consul_service" {
  description = "If you want to register a consul service for the job"
  type        = bool
  default     = true
}

variable "consul_registry_service_name" {
  description = "The consul service name for the registry application"
  type        = string
  default     = "registry"
}

variable "consul_ui_service_name" {
  description = "The consul service name for the registry application"
  type        = string
  default     = "registry"
}

variable "consul_registry_service_tags" {
  description = "The consul service name for the registry application"
  type        = list(string)
  default = []
}

variable "consul_ui_service_tags" {
  description = "The consul service name for the registry application"
  type        = list(string)
  default = []
}

variable "resources" {
  description = "The resource to assign to the registry service task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 200,
    memory = 256
  }
}

variable "registry_config" {
  description = "The yaml configuration for the registry"
  type        = string
}

variable "registry_task" {
  description = "Details configuration options for the promlens task."
  type        = object({
    driver  = string
    image   = string
    version = string
  })
  default = {
    driver  = "docker",
    image   = "distribution/registry",
    version = "latest",
  }
}

variable "ui_env_vars" {
  description = "env vars to inject"
  type = list(object({
    key   = string
    value = string
  }))
  default = [
    {key = "DELETE_IMAGES", value = "true"},
    {key = "SINGLE_REGISTRY", value = "true"},
  ]
}

variable "ui_task" {
  description = "Details configuration options for the promlens task."
  type        = object({
    driver  = string
    image   = string
    version = string
  })
  default = {
    driver  = "docker",
    image   = "joxit/docker-registry-ui",
    version = "latest",
  }
}
