{ pkgs, ... }:

{
  services.gnome3 = {
    core-shell.enable = true;
    gnome-settings-daemon.enable = true;
    core-utilities.enable = true;
    core-os-services.enable = true;
  };

  environment.systemPackages = with pkgs;
    (with gnome3;
      [
        # Gnome specific packages
        gnome-tweak-tool

      ]) ++ (with gnomeExtensions; [
        pop-shell
        caffeine
        workspace-matrix
        clipboard-indicator
        night-theme-switcher
      ]);
}
