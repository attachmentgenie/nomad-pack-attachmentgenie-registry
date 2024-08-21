app {
  url = "https://github.com/dmaes/nomad-logger/tree/main"
}

pack {
  name        = "nomad_logger"
  description = "This is a simple Go application that polls the Nomad API for all allocations on a certain host, and then updates the config of you log shipper of choice."
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "79b6a981"
}
