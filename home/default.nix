{ pkgs, config, ... }:

{
  imports = [
    # ./home-manager.nix
    ./styles.nix
    ./fontawesome.nix
  ];

  environment.systemPackages = builtins.trace (config.fontawesome.wifi) [];
  # options.variables = mkOption { type = types.uniq types.unspecified types.unspecified; default = {}; };
  # programs.home-manager.enable = true;
}
