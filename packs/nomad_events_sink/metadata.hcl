app {
  url = "https://github.com/attachmentgenie/nomad-events-sink"
}

pack {
  name        = "nomad_events_sink"
  description = "An events collection agent which processes Nomad Events and dumps to external sink providers like HTTP"
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "c9bf50a9"
}
