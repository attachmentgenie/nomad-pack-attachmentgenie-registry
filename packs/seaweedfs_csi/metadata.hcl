app {
  url = "https://github.com/seaweedfs/seaweedfs-csi-driver"
}

pack {
  name        = "seaweedfs_csi"
  description = "Container Storage Interface (CSI) for SeaweedFS"
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "c9bf50a9"
}