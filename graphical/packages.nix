{pkgs, config, ...}:
{
  programs.wireshark = {
    package = pkgs.wireshark-gtk;
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    pkgs.channels."nixos-${config.system.stateVersion}".libreoffice-fresh
    blender
    gparted
    keepassxc
    konsole-fix.konsole
    steam-fix.steam
    steam-fix.steam-run-native
    virtualbox
    xfce.thunar
    xfce.thunar_volman
    spotify
    vlc
    firefox
    qbittorrent
    exiftool
    darktable
    gimp
    inkscape
  ];
}
