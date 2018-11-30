{pkgs, ...}:
{
  programs.wireshark = {
    package = pkgs.wireshark-gtk;
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    dropbox
    libreoffice-fix.libreoffice
    blender
    gparted
    keepassxc
    optimised.lxqt.qterminal
    steam-fix.steam
    steam-fix.steam-run-native
    syncthing
    virtualbox
    xfce.thunar
    xfce.thunar_volman
    spotify
    system-config-printer
    arduino
    vlc
    firefox
    qbittorrent
    exiftool
    darktable
    gimp
    inkscape
  ];
}
