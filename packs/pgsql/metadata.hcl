app {
  url = "https://www.postgresql.org/"
}

pack {
  name        = "pgsql"
  description = "PostgreSQL, also known as Postgres, is a free and open-source relational database management system"
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "782df6bb"
}
