let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in {
  environment.systemPackages = [
    # Install stable HIE for GHC versions 8.6.4 and 8.6.5 if available and fall back to unstable otherwise
    # (all-hies.unstableFallback.selection { selector = p: { inherit (p) ghc864 ghc865; }; })

    # Install unstable HIE for GHC versions 8.4.4 and 8.6.5
    (all-hies.unstable.selection { selector = p: { inherit (p) ghc865; }; })
  ];
}
