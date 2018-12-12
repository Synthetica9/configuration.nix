#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash curl ripgrep jq

set -euxo pipefail

CURL="curl -v"

BASEURL="https://channels.nix.gsc.io/"
CHANS=$($CURL "$BASEURL" | rg 'href="(nix[\w\d\-\.)]+)/"' --replace '$1' --only-matching)

for CHAN in $CHANS;
do
  COMMIT=$($CURL "$BASEURL/$CHAN/latest" | awk '{ print $1 }')
  jq -n '{ commit: $commit, name: $name }' --arg commit $COMMIT --arg name $CHAN
done | jq -s | tee ./channels/defs.json
