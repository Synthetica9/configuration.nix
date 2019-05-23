{pkgs, ...}:

let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
in
{ nixpkgs.overlays = [ moz_overlay ]; }
