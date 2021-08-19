{ pkgs, config, lib, ... }:

let
  defs = lib.importJSON ./defs.json;
  channels' = lib.listToAttrs (map (val: {
    name = val.name;
    value = builtins.fetchTarball {
      url = "https://github.com/nixos/Nixpkgs/archive/${val.commit}.tar.gz";
      name = lib.debug.traceVal
        "${val.name}-${val.date}-${lib.substring 0 7 val.commit}";
    };
  }) defs);
  channels = lib.mapAttrs (key: val:
    import val {
      inherit (config.nixpkgs)

        config

        overlays

        localSystem

        crossSystem

      ;
    }) channels';

  deployConfig = fetchTarball {
    url =
      "https://github.com/synthetica9/configuration.nix/archive/deploy.tar.gz";
    name = "deploy";
  };
  mainChan = "nixos-unstable";
in {
  nixpkgs.config.packageOverrides = {
    inherit channels channels';
    nixos-current = channels."nixos-${config.system.stateVersion}";
  } // channels;
  nixpkgs.pkgs = channels."${mainChan}";
  nix.nixPath = [
    "nixpkgs=${channels'."${mainChan}"}"
    "nixos-config=${deployConfig}/build_support/activate.nix"
  ];
}
