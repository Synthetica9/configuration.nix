{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager."sway";
in

{

  ###### interface

  options = {
    services.xserver.windowManager."sway".enable = mkEnableOption "sway";
  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "sway";
        start =
          ''
            ${pkgs.sway}/bin/sway &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ pkgs.sway ];

  };

}
