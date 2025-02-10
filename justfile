
_default:
    @just -l

update_vendor_packs:
  #!/usr/bin/env bash
  set -euo pipefail

  for f in packs/*; do
      if [ -d "$f" ] && [ "$f" != "packs/attachmentgenie_pack_helpers" ]; then
        echo "$f"
        if test -f $f/metadata.hcl; then
            nomad-pack deps vendor --path=$f
        fi
      fi
  done
