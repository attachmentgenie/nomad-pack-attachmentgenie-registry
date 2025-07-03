app {
  url = "https://heimdall.site"
}

pack {
  name        = "heimdall"
  description = "Heimdall Application Dashboard is a dashboard for all your web applications."
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "782df6bb"
}
