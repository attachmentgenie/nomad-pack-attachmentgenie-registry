app {
  url = "https://kafka.apache.org/"
}

pack {
  name        = "kafka"
  description = "Apache Kafka is an open-source distributed event streaming platform"
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "782df6bb"
}
