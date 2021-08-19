let
    lib = import <nixpkgs/lib>;

    hostname = "AquaRing";
in
    import ../. hostname /mnt/etc/nixos/hardware-configuration.nix
