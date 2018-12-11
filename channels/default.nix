{ pkgs, config, lib, ... }:

let
  defs = lib.importJSON ./defs.json;
  channels' = lib.listToAttrs (map (val: {
    name = val.name;
    value = builtins.fetchTarball "https://github.com/nixos/Nixpkgs/archive/${val.commit.sha}.tar.gz";
  }) defs);
  channels = lib.mapAttrs (key: val: import val {
    config = config.nixpkgs.config;
  }) channels';
in
{
  nixpkgs.config.packageOverrides = { inherit channels channels'; } // channels;
  nix.nixPath = [ "nixpkgs=${channels'.nixos-unstable-small}" ];
}
