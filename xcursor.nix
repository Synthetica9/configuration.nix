{ config, lib, pkgs, ... }:
 
with lib;
 
let
  cfg = config.xcursor;
 
in {
  options.xcursor = {
    theme = mkOption {
      default = "Premium";
      type = types.str;
      description = ''
        The X cursor theme to apply.
      '';
    };
  };
 
  config = {
    environment = {
      profileRelativeEnvVars.XCURSOR_PATH = [ "/share/icons" ];
 
      etc."xdg/gtk-3.0/settings.ini" = {
        text = ''
          [Settings]
          gtk-cursor-theme-name=${cfg.theme}
        '';
        mode = "444";
      };
 
      systemPackages = [
        (pkgs.callPackage ({ stdenv }: stdenv.mkDerivation rec {
          name = "default-xcursor-theme";
          phases = [ "installPhase" ];
          installPhase = ''
            mkdir -p $out/share/icons/default
            cat <<'EOL' > $out/share/icons/default/icon.theme
            [Icon Theme]
            Inherits=${cfg.theme}
            EOL
            ln -s /run/current-system/sw/share/icons/${cfg.theme}/cursors $out/share/icons/default/cursors
          '';
          meta = {
            description = "Install the default X cursor theme globally.";
          };
        }) { })
      ];
 
      pathsToLink = [ "/share/icons" ];
    };
  };
}
