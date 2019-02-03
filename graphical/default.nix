{ ... }:

{
  imports = [
    ../workstation

    ./vscode.nix
    ./theming.nix
    ./desktop.nix
    ./packages.nix
    ./audio.nix
  ];
}
