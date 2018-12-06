{ pkgs, ...}:

# VScode and related packages and settings
{
  environment.systemPackages = with pkgs; [
    vscode
    python3Packages.autopep8
    haskellPackages.stylish-haskell
  ] ++ (with haskellPackages; [
    hlint
  ]);
  # security.polkit.enable = true;
  environment.variables = rec {
    EDITOR = "code --wait";
    VISUAL = EDITOR;
  };
}
