{ pkgs, ... }:
{
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraConfig = ''
      load-module module-switch-on-connect
      unload-module module-suspend-on-idle
    '';
  };
}
