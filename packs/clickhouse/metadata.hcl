app {
  url = "https://clickhouse.com/"
}

pack {
  name        = "clickhouse"
  description = "ClickHouse is an open-source column-oriented DBMS (columnar database management system) for online analytical processing."
  version     = "0.1.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "782df6bb"
}
