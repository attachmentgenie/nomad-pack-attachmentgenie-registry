app {
  url = "https://heimdall.site"
}

pack {
  name        = "heimdall"
  description = "Heimdall Application Dashboard is a dashboard for all your web applications."
  version     = "0.1.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "c9bf50a9"
}
