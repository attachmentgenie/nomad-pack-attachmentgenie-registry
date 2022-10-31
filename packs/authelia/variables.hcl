variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name"
  type        = string
  // If "", the pack name will be used
  default = ""
}

variable "namespace" {
  description = "The namespace where the job should be placed"
  type        = string
  default     = "default"
}

variable "region" {
  description = "The region where the job should be placed"
  type        = string
  default     = "global"
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement"
  type        = list(string)
  default     = ["lab"]
}

variable "count" {
  description = "The number of app instances to deploy"
  type        = number
  default     = 1
}

variable "env_vars" {
  description = "env vars to inject"
  type = list(object({
    key   = string
    value = string
  }))
}

variable "register_consul_service" {
  description = "If you want to register a consul service for the job"
  type        = bool
  default     = true
}

variable "consul_service_name" {
  description = "The consul service name for the authelia application"
  type        = string
  default     = "authelia"
}

variable "consul_service_tags" {
  description = "The consul service name for the authelia application"
  type        = list(string)
  default = [
  "traefik.enable=true",
]
}

variable "authelia_task_app_configuration_yaml" {
  description = "The authelia configuration to pass to the task."
  type        = string
  default     = <<EOH
---
jwt_secret: a_very_important_secret
default_redirection_url: https://public.example.com
server:
  host: 0.0.0.0
  port: 9091
log:
  level: debug
totp:
  issuer: authelia.com
authentication_backend:
  file:
    path: /config/users_database.yml
access_control:
  default_policy: deny
  rules:
    - domain: public.example.com
      policy: bypass
    - domain: traefik.example.com
      policy: one_factor
    - domain: secure.example.com
      policy: two_factor
session:
  name: authelia_session
  secret: unsecure_session_secret
  expiration: 3600
  inactivity: 300
  domain: example.com
regulation:
  max_retries: 3
  find_time: 120
  ban_time: 300
storage:
  encryption_key: you_must_generate_a_random_string_of_more_than_twenty_chars_and_configure_this
  local:
    path: /config/db.sqlite3
notifier:
  filesystem:
    filename: /config/notification.txt
...
EOH
}

variable "authelia_task_app_users_database_yaml" {
  description = "The authelia users database configuration to pass to the task."
  type        = string
  default     = <<EOH
users:
  attachmentgenie:
    displayname: "attachmentgenie"
    password: "$argon2id$v=19$m=65536,t=3,p=4$OHZqdUJXR21jWWpVbWNoMA$PYepxSPDvRra6DX4SmeNHaSAPEqdjq0GbizlihDiNQI"
    email: bram@attachmentgenie.com
    groups:
      - admins
      - dev
EOH
}