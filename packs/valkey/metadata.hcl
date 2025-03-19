app {
  url = "https://valkey.io/"
}

pack {
  name        = "Valkey"
  description = "Valkey is an open source (BSD) high-performance key/value datastore"
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "782df6bb"
}
