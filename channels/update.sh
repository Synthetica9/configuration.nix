#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash curl

set -euxo pipefail

curl "https://api.github.com/repos/nixos/nixpkgs-channels/branches" | tee channels/defs.json
