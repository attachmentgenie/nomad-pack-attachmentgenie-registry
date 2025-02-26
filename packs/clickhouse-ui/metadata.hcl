app {
  url = "https://github.com/caioricciuti/ch-ui"
}

pack {
  name        = "ch-ui"
  description = "A modern, feature-rich web interface for ClickHouse databases."
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "782df6bb"
}
