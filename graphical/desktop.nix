{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e, ctrl:swapcaps";
      # Enable touchpad support.
      libinput = {
        enable = true;
        naturalScrolling = true;
      };

      # displayManager.sddm.enable = true;
      displayManager.lightdm = {
        enable = true;
        background = builtins.fetchurl {
          url = "https://unsplash.com/photos/KqVHRmHVwwM/download?force=true";
          sha256 = "1gk8zd57qi31qpp8kj04hgjwp4mrz5bwfpqxzksfsg6jrrmx22cn";
        };
      };

      desktopManager.xterm.enable = false;
      windowManager.i3 = {
        enable = true;
        package = pkgs.optimised.i3-gaps;
      };

      desktopManager.xfce = {
        enable = true;
        thunarPlugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar_volman
          thunar-dropbox-plugin
        ];

        # "Don't install XFCE desktop components (xfdesktop, panel and notification
        # daemon).";
        noDesktop = true;
      };
    };

    redshift = {
      enable = true;
      latitude = "52";
      longitude = "5";
      temperature = {
        day = 6500;
        night = 3700;
      };
    };

    compton = {
      enable = true;
      inactiveOpacity = "0.90";
      fade = true;
      fadeDelta = 3;
      opacityRules = [
        "50:name = 'i3lock'"
        "99:class_g = 'Firefox'"
        "99:class_g = 'Gnome-mpv'"
      ];
    };
    gnome3.gvfs.enable=true;
    davfs2.enable=true;
  };

  systemd.user.services = {
    "auto_brightness" = {
      enable = true;
      description = "Auto brightness adjustment";
      wantedBy = [ "multi-user.target" "sleep.target" ];
      after = [ "supend.target" ];
      path = [ pkgs.python3 pkgs.xorg.xbacklight ];
      environment = {
        PYTHONPATH = "${pkgs.python36Packages.ephem}/lib/python3.6/site-packages/";
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.python3}/bin/python /home/synthetica/bin/auto_brightness"; # TODO: make this a package?
        User="synthetica";
        # ExecStart = "${pkgs.python3}/bin/python -c 'import sys; print(sys.path)'";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    albert
    pavucontrol
    arc-theme
    feh
    fontconfig-ultimate
    gksu
    gnome2.gnome_icon_theme
    gnome3.adwaita-icon-theme
    gnome3.file-roller
    gtk-engine-murrine
    gtk_engines
    gvfs
    i3-wk-switch
    i3lock-color
    kdeFrameworks.networkmanager-qt
    networkmanagerapplet
    notify-desktop
    numix-cursor-theme
    compton
    playerctl
    redshift
    screenkey
    shutter
    xdotool
    xfce.xfce4notifyd
    xfce.xfce4settings
    xfce.xfce4volumed
    xorg.xbacklight
    xorg.xrefresh
    xss-lock
    rofi
    xclip
    wmfocus
  ];
}
