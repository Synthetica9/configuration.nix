#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash jq curl

set -euxo pipefail

curl "https://api.github.com/repos/nixos/nixpkgs-channels/branches" -o channels/defs.json
