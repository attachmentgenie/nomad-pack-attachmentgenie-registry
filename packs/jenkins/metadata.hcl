app {
  url    = "https://www.jenkins.io/"
}

pack {
  name        = "jenkins"
  description = "Jenkins is an open source automation server which enables developers around the world to reliably build, test, and deploy their software."
  version     = "0.1.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "2600e33c"
}
