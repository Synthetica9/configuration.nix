{pkgs, config, ...}:
{
  programs.wireshark = {
    package = pkgs.wireshark-gtk;
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    pkgs.nixos-current.libreoffice-fresh
    blender
    gparted
    keepassxc
    konsole-fix.konsole
    steam-fix.steam
    steam-fix.steam-run-native
    nixos-current.virtualbox
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
