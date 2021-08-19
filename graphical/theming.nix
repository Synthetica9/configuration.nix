{ pkgs, ... }:

{
  imports = [ ./xcursor.nix ];
  xcursor.theme = "Numix";

  environment.etc."gtk-3.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-theme-name=Adwaita
      gtk-fallback-icon-theme=gnome
      # gtk-toolbar-style=GTK_TOOLBAR_BOTH
      # gtk-font-name=Droid Sans 6
      gtk-application-prefer-dark-theme=1
      gtk-cursor-theme-name=Numix
      # gtk-cursor-theme-size=0
      # gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
      # gtk-button-images=1
      # gtk-menu-images=1
      # gtk-enable-event-sounds=1
      # gtk-enable-input-feedback-sounds=1
      # gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle=hintfull
      gtk-xft-rgba=none
      # gtk-icon-theme-name=Faenza-Ambiance
      # gtk-toolbar-icon-size=GTK_ICON_SIZE_SMALL_TOOLBAR
    '';
    mode = "444";
  };

  # https://github.com/dlukes/dotfiles/blob/master/configuration.nix#L323
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts # Microsoft free fonts
      dejavu_fonts
      symbola
      emojione
      fira-code
      iosevka
      helvetica-neue-lt-std
      powerline-fonts
      ubuntu_font_family
      xorg.fontbhlucidatypewriter100dpi
      font-awesome-ttf
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Ubuntu" ];
        monospace = [ "Fira Code" ];
        emoji = [ "Noto Sans Emoji" ];
      };

      # ultimate.enable = true;
    };
  };

  # GTK2 global theme (widget and icon theme)
  environment.etc."gtk-2.0/gtkrc" = {
    text = ''
      gtk-theme-name="Arc-Dark"
      gtk-icon-theme-name="adwaita"
      gtk-font-name="Sans 10"
      gtk-cursor-theme-name="numix"
    '';
    mode = "444";
  };

  # QT4/5 global theme
  environment.etc."xdg/Trolltech.conf" = {
    text = ''
      [Qt]
      style=Arc-Dark
    '';
    mode = "444";
  };
}
