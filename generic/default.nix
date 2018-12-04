{ ... }:

{
  imports = [
    ./overrides.nix
    ./remotes.nix
    ./buildFlags.nix
    ./options.nix
    ./nix.nix
    ./networking.nix
    ./kernel.nix
    ./boot.nix
  ];
}
