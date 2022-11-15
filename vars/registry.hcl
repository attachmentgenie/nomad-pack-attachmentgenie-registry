registry_config = <<EOF
---
version: 0.1
http:
  addr: :5000
  headers:
    X-Content-Type-Options: [nosniff]
    Access-Control-Allow-Origin: ['https://images.teambla.dev']
    Access-Control-Allow-Methods: ['HEAD', 'GET', 'OPTIONS', 'DELETE']
    Access-Control-Allow-Headers: ['Authorization', 'Accept']
    Access-Control-Max-Age: [1728000]
    Access-Control-Allow-Credentials: [true]
    Access-Control-Expose-Headers: ['Docker-Content-Digest']
storage:
  delete:
    enabled: true
  filesystem:
    rootdirectory: /var/lib/registry
EOF
ui_env_vars  = [
  {key = "DELETE_IMAGES", value = "true"},
  {key = "REGISTRY_TITLE", value = "Lab Registry"},
  {key = "SINGLE_REGISTRY", value = "true"},
  {key = "NGINX_PROXY_PASS_URL", value = "http://registry.service.consul:5000"}
]
