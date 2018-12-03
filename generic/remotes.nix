{ lib, config, pkgs, ... }:

# https://gist.github.com/joepie91/ce9267788fdcb37f5941be5a04fcdd0f#installing-a-few-packages-from-master

let
  nixpkgsRemote = remote: rev: import (builtins.fetchTarball "https://github.com/${remote}/Nixpkgs/archive/${rev}.tar.gz") {
    config = config.nixpkgs.config;
  };

  remotes = lib.mapAttrs (_: nixpkgsRemote) {
    upstream = "nixos";
    devel = "synthetica9";
  };
in
{
  nixpkgs.config.packageOverrides = {
    hieRemote = import (builtins.fetchTarball "https://github.com/domenkozar/hie-nix/archive/master.tar.gz") {};

    master = builtins.trace
      "Warning: master is impure. Using this might have unexpected consequences!"
      (remotes.upstream "master");
    haskell-fix     = remotes.upstream "69fa2d6bfba";
    libreoffice-fix = remotes.upstream "81f5c2698a8";
    steam-fix = remotes.devel "steamRuntimeRefactor";
    konsole-fix = remotes.devel "konsole-keyboard-fix";
  };
}
