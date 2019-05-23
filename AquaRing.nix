{ pkgs, ... }:

{
  imports = [ ./graphical ./sway.nix ];

  arch = "broadwell";

  environment.variables = {
    "QT_SCALE_FACTOR" = "1";
  };

  services.xserver.windowManager.sway.enable = true;
}
