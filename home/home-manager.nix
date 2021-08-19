{ ... }:
let
  home-manager-repo = builtins.fetchTarball "https://github.com/rycee/home-manager/archive/master.tar.gz";
in
{
  imports = [ "${home-manager-repo}/nixos" ];
  # programs.home-manager.enable = true;
}
