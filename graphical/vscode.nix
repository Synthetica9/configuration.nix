{ pkgs, ...}:

# VScode and related packages and settings
{
  environment.systemPackages = with pkgs; [
    # vscode
    vscodium
    # rls
    rustfmt
    ormolu
    python3Packages.autopep8
    # python3Packages.python-language-server
#    haskellPackages.stylish-haskell
#  ] ++ (with haskellPackages; [
#    hlint
   ];
  # security.polkit.enable = true;
  environment.variables = rec {
    EDITOR = "code --wait";
    VISUAL = EDITOR;
  };
}
