app {
  url = "https://github.com/Joxit/docker-registry-ui"
}

pack {
  name        = "docker-registry-ui"
  description = "This project aims to provide a simple and complete user interface for your private docker registry."
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "782df6bb"
}
