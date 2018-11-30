{ lib, ... }:

with lib;
{
  options.arch = mkOption {
    default = null;
    description = ''
      The architecture of the CPU
    '';
    type = types.nullOr types.str;
  };
}
