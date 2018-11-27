let
    lib = import <nixpkgs/lib>;

    hostname = lib.removeSuffix "\n" (builtins.readFile "/etc/hostname");
in
    import ./. hostname /etc/nixos/hardware-configuration.nix