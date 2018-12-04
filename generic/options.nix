{ lib, ... }:

with lib;

let
  mergeNullOption = loc: defs:
    if length defs != 1 then null
    else (head defs).value;
in
{
  options.arch = mkOption {
    default = null;
    description = ''
      The architecture of the CPU
    '';
    type = types.nullOr types.str // { merge = mergeNullOption; };
  };

  options.isTesting = mkOption {
    default = false;
    description = ''
      Whether this is a test build
    '';
    type = types.bool;
  };
}
