{ pkgs, config, ... }: {
  programs.wireshark = {
    package = pkgs.wireshark-qt;
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    # blender
    # darktable
    exiftool
    gimp
    gnuplot
    gparted
    hopper
    inkscape
    keepassxc
    # konsole
    alacritty
    # firefox
    latest.firefox-bin
    libreoffice-fresh
    megasync
    pdfpc
    qbittorrent
    transmission_remote_gtk
    qt5.qtwayland
    # plex-media-player
    plexamp
    pulseeffects-legacy
    # scribus
    spotify
    vlc
    # virtualbox
    xfce.thunar
    # calibre
    zathura
    piper
  ];

  # services.spotifyd.enable = true;
  services.ratbagd.enable = true;
}
