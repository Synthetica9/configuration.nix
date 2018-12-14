#! /usr/bin/env nix-shell
#! nix-shell -p bash -i bash git

set -euxo pipefail

UPDATE_PATH=":/channels/defs.json"

# Check if we weren't broken before
if make
then
  # Deploy anyways, even if our upgrades fail.
  DEPLOY=true
fi

# Update our channels to the latest definitions.
# Possible future improvement: bisect to last working channel.
make update

# Show the differences with the old output
git --no-pager diff -- "$UPDATE_PATH"

if make
then
  # The upgrades possibly _fixed_ our builds
  DEPLOY=true
else
  # The upgrades broke our build, but the original build might still be valid.
  git checkout -- "$UPDATE_PATH"
fi

if [ "${TRAVIS_BRANCH-}" = "deploy" ]
then
  # If we are on the deploy branch, there _MUST_ be changes, otherwise we
  # shouldn't deploy (otherwise we trigger an infinite build loop. Yes, been
  # there, done that, 👕).
  ! git diff --exit-code --quiet -- "$UPDATE_PATH" || unset DEPLOY
fi

# Fail if we shouldn't deploy!
([ -n "${DEPLOY-}" ] && echo "DEPLOYING! 👍") || (echo "Not deploying! 👎" && false)
