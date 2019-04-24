{ lib, config, ... }:

# https://gist.github.com/joepie91/ce9267788fdcb37f5941be5a04fcdd0f#installing-a-few-packages-from-master

let
  nixpkgsRemote = remote: rev: import (builtins.fetchTarball "https://github.com/${remote}/Nixpkgs/archive/${rev}.tar.gz") {
    config = config.nixpkgs.config;
  };

  remotes = lib.mapAttrs (_: nixpkgsRemote) {
    upstream = "nixos";
    devel = "synthetica9";
  };
in with remotes;
{
  nixpkgs.config.packageOverrides = {
    # WARNING! Don't name the remote the same as the package you're trying to
    # install, the package will get overridden
    hieRemote = import (builtins.fetchTarball "https://github.com/domenkozar/hie-nix/archive/master.tar.gz") {};

    master = builtins.trace
      "Warning: master is impure. Using this might have unexpected consequences!"
      (upstream "master");
    steam-fix = devel "steamRuntimeRefactor";
    konsole-fix = devel "konsole-keyboard-fix";
    cachix-fix = upstream "059c61d001fd32b4a1f5d3190e9c0d798570b4b3";
  };
}
