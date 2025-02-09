app {
  url = "https://joxit.dev/docker-registry-ui/"
}

pack {
  name        = "registry"
  description = "The simplest and most complete UI for your private registry"
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "782df6bb"
}
