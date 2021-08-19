{ pkgs, lib, options, ... }:

with lib;
let
  exportJSON = name: e: pkgs.writeTextFile {
    inherit name;
    text = builtins.toJSON e;
  };

  rev = "97d8ab4436e7bf9f55318e432d7805c13b50e27e";
  json = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/gluons/Font-Awesome-Icon-Chars/${rev}/character-list/character-list.json";
    sha256 = "1syl21bj3vyr1ci9i2343nmdxbyv6z6qqnxgmmsz6fk5yh5g1szp";
  };
  raw = importJSON json;
  combined = with raw; regular ++ solid ++ brands;
  converted = listToAttrs (map
    ({name, unicode}: nameValuePair name "&#x${unicode};")
    combined
  );
  recoded = pkgs.runCommand "fontawesome-unicode.json" {} ''
    cat ${exportJSON "converted.json" converted} | ${pkgs.recode}/bin/recode html..utf8 > "$out"
  '';
  fontawesome = importJSON recoded;
in
{
  options.fontawesome = mkOption {
    readOnly = true;
    default = fontawesome;
  };
}
