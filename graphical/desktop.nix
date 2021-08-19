{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      autorun = false;
      layout = "us";
      xkbOptions = "eurosign:e, ctrl:swapcaps";

      # displayManager.lightdm.enable = pkgs.lib.mkForce false;
      # displayManager.lightdm.greeters.gtk.enable = pkgs.lib.mkForce false;
      # displayManager.job.execCmd = "${pkgs.coreutils}/bin/false";

      desktopManager.xfce = {
        # enable = true;
        thunarPlugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar_volman
          thunar-dropbox-plugin
        ];

        # "Don't install XFCE desktop components (xfdesktop, panel and notification
        # daemon).";
        noDesktop = true;
      };

      # desktopManager.gnome = { enable = true; };
      # desktopManager.plasma5.enable = true;
    };
  };
  programs.sway.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
  xdg.portal.enable = true;

  environment.systemPackages = with pkgs; [
    albert
    compton
    feh
    gksu
    gnome2.gnome_icon_theme
    gnome3.adwaita-icon-theme
    gnome3.file-roller
    grim
    gvfs
    i3-wk-switch
    i3status
    libinput-gestures
    mako
    networkmanagerapplet
    notify-desktop
    numix-cursor-theme
    pavucontrol
    playerctl
    pywal
    redshift
    rofi
    swaylock
    sway-contrib.inactive-windows-transparency
    sxiv
    waybar
    wl-clipboard
    xclip
    wmfocus
    xorg.xbacklight
    xorg.xrefresh
    xss-lock
  ];

  environment.variables.GIO_EXTRA_MODULES = [ "${pkgs.gvfs}/lib/gio/modules" ];

  programs.light.enable = true;
}
