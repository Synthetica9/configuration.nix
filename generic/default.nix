{ ... }:

{
  imports = [
    ./overrides.nix
    ./remotes.nix
    ./buildFlags.nix
    ./arches.nix
    ./nix.nix
    ./networking.nix
    ./kernel.nix
    ./boot.nix
  ];
}
