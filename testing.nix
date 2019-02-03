{ lib, ... }: {
  isTesting = true;
  imports = lib.mapAttrsToList (_: value: value) (import ./machines.nix);
  arch = null;
}
