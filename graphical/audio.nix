{ pkgs, ... }: {
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
    extraConfig = ''
      load-module module-switch-on-connect
      unload-module module-suspend-on-idle
    '';
    systemWide = false;
    # systemWide = true;
  };
  # sound = {
  #   enable = true;
  #   # extraConfig = ''
  #   #   defaults.pcm.!card 1
  #   #   defaults.ctl.!card 1
  #   # '';
  # };
}
