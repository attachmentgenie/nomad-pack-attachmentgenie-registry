app {
  url = "https://www.nomadproject.io/docs/autoscaling"
}

pack {
  name        = "nomad_autoscaler"
  description = "The Nomad Autoscaler is an autoscaling daemon for Nomad, architectured around plugins to allow for easy extensibility in terms of supported metrics sources, scaling targets and scaling algorithms."
  version     = "0.2.0
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "92d4feb5"
}
