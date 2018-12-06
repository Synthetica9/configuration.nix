{pkgs, options, lib, config, ...}:

let
  overrideCFlags = pkg: flags:
    pkgs.lib.overrideDerivation pkg (old:
    let
      newflags = pkgs.lib.foldl' (acc: x: "${acc} ${x}") "" flags;
      oldflags = if (pkgs.lib.hasAttr "NIX_CFLAGS_COMPILE" old)
        then old.NIX_CFLAGS_COMPILE
        else "";
    in
    {
      NIX_CFLAGS_COMPILE = "${oldflags} ${newflags}";
    });
  optimiseForThisHost = pkg:
    overrideCFlags pkg [ "-O3" "-march=${options.arch.value}" "-fPIC" ];

  withDebuggingCompiled = pkg:
    overrideCFlags pkg [ "-DDEBUG" ];
in
{
  nixpkgs.config.packageOverrides = pkgs: rec {
    # Optimization:
    optimised = if config.arch == null then pkgs else
      lib.mapAttrsRecursiveCond (as : as ? "type" -> as.type != "derivation")
        (path: value: builtins.trace "Optimising ${lib.concatStringsSep "." path}" optimiseForThisHost value) pkgs;
  };
}
