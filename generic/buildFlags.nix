{pkgs, options, lib, config, ...}:

let
  overrideCFlags = flags: pkg:
    lib.overrideDerivation pkg (old:
    let
      oldflags = old.NIX_CFLAGS_COMPILE or [];
    in
    builtins.trace "Compiling ${old.name} with ${lib.strings.concatStringsSep " " flags}" {
      NIX_CFLAGS_COMPILE = oldflags ++ flags;
    });

  subuniverse = pkgs: f:
    lib.mapAttrsRecursiveCond (as: as ? "type" -> as.type != "derivation")
      (_: f) pkgs;

  cFlagSubuniverse = pkgs: flags: subuniverse pkgs (overrideCFlags flags);
in
{
  nixpkgs.config.packageOverrides = pkgs: lib.mapAttrs (_: cFlagSubuniverse pkgs) {
    # Optimization:
    optimised = [ "-O3" "-fPIC"  ] ++ lib.optional (config.arch != null) "-march=${options.arch.value}";
    debugged = [ "-DDEBUG" "-fsanitize=address" ];
  };
}
