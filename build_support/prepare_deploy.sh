#! /usr/bin/env nix-shell
#! nix-shell -p bash -i bash git

set -euxo pipefail

# Check if we weren't broken before
if make
then
  # Deploy anyways, even if our upgrades fail.
  DEPLOY=true
fi

# Update our channels to the latest definitions.
# Possible future improvement: bisect to last working channel.
make update

if make
then
  # The upgrades possibly _fixed_ our builds
  DEPLOY=true
else
  # The upgrades broke our build, but the original build might still be valid.
  git checkout -- :/channels/defs.json
fi

# Fail if we shouldn't deploy!
[ -n "${DEPLOY+}" ] && echo "DEPLOYING! 👍" || (echo "Not deploying! 👎" && false)
