{pkgs, config, ...}:
{
  programs.wireshark = {
    package = pkgs.wireshark-qt;
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    pkgs.nixos-current.libreoffice-fresh
    blender
    gparted
    keepassxc
    scribus
    qt5.qtwayland
    konsole
    steam-fix.steam
    steam-fix.steam-run-native
    nixos-current.virtualbox
    xfce.thunar
    xfce.thunar_volman
    spotify
    vlc
    # latest.firefox-nightly-bin
    latest.firefox-bin
    qbittorrent
    exiftool
    darktable
    gimp
    inkscape
    pkgs.nixos-current.octaveFull
    pkgs.gnuplot
    zathura
  ];
}
