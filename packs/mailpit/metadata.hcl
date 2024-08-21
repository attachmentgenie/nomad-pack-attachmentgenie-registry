app {
  url = "https://github.com/axllent/mailpit"
}

pack {
  name        = "mailpit"
  description = "Mailpit is a multi-platform email testing tool for developers."
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "79b6a981"
}
