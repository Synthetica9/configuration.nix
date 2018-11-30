{ pkgs, ...}:

# VScode and related packages and settings
{
  environment.systemPackages = with pkgs; [
    vscode
    python3Packages.autopep8
    haskellPackages.stylish-haskell
  ];
  security.polkit.enable = true;
  environment.variables = {
    "EDITOR" = "code --wait";
    "VISUAL" = "code --wait";
  };
}
