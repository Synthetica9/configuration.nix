{ pkgs, ... }:
let
  texlive-custom = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-medium
      # For LuaLaTeX & Pandoc interaction
      ifoddpage relsize xifthen ifmtarg datatool xfor substr trimspaces
      tikz-network
      cleveref
      titlesec
      tkz-orm
      tufte-latex hardwrap
      lipsum
    ;
  };
in
{
  environment.systemPackages = with pkgs; [
    pandoc
    texlive-custom
  ];
}
