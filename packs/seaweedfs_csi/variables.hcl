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
    cpu    = 512,
    memory = 1024,
  }
}

variable "image_name" {
  description = "The docker image name."
  type        = string
  default     = "chrislusf/seaweedfs-csi-driver"
}

variable "image_tag" {
  description = "The docker image tag."
  type        = string
  default     = "v1.2.2"
}

variable "cli_args" {
  description = "cli arguments to pass to the csi driver"
  type        = list(string)
  default = [
    "--endpoint=unix://csi/csi.sock",
    "--filer=$${attr.unique.network.ip-address}:8888",
    "--nodeid=$${node.unique.name}",
    "--cacheCapacityMB=256",
    "--cacheDir=$${NOMAD_TASK_DIR}/cache_dir",
  ]
}
