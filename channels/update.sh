#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash curl ripgrep jq

set -euxo pipefail

CURL="curl -v"

BASEURL="https://channels.nix.gsc.io/"
CHANS=$($CURL "$BASEURL" | rg 'href="(nix[\w\d\-\.)]+)/"' --replace '$1' --only-matching)

for CHAN in $CHANS;
do
  LINE=$($CURL "$BASEURL/$CHAN/latest")
  COMMIT=$(awk '{ print $1 }' <<< $LINE)
  DATE=$(awk '{ print strftime("%F", $2); }' <<< $LINE )
  jq --null-input '{ commit: $commit, name: $name, date: $date }' --arg commit $COMMIT --arg name $CHAN --arg date $DATE
done | jq --slurp | tee ./channels/defs.json
