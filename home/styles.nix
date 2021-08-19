{ pkgs, lib, options, ... }:

with lib;
let
  inherit (pkgs.scss-to-json-init.nodePackages) scss-to-json;

  json = pkgs.runCommand "styles.json" {} ''
    ${scss-to-json}/bin/scss-to-json ${./styles.scss} > "$out"
  '';
  styles =
    mapAttrs (key: value: nameValuePair (removePrefix "$" key) (value))
      (importJSON json);
in
{
  options.styles = mkOption {
    readOnly = true;
    default = styles;
  };
}
