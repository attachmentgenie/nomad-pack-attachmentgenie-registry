app {
  url = "https://github.com/attachmentgenie/golang-example"
}

pack {
  name        = "example"
  description = "nomad-pack pack template"
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "79b6a981"
}
