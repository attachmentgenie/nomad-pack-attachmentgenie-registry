app {
  url = "https://www.mysql.com/"
}

pack {
  name        = "mysql"
  description = "MySQL is an open-source relational database management system."
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "92d4feb5"
}
