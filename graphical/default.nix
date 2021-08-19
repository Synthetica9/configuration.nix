{ ... }:

{
  imports = [
    ../workstation
    # ../home

    ./vscode.nix
    ./theming.nix
    ./desktop.nix
    ./packages.nix
    ./audio.nix
    ./moz_overlay.nix
    # ./gnome.nix
  ];
}
