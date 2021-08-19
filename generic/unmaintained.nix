{ config, lib, ... }: {
  warnings = let
    unmaintained = lib.filter
      (v: v ? pname && v ? meta.maintainers && v.meta.maintainers == [ ])
      config.environment.systemPackages;
  in lib.optional (unmaintained != [ ])
  "These packages you're using don't have a maintainer: ${
    lib.concatMapStrings (v: ''

      - ${v.pname}'') unmaintained
  }";
}
