{ pkgs, ... }:
{
  boot = let kernelPackages = pkgs.nixos-current.linuxPackages; in {
    inherit kernelPackages;
    tmpOnTmpfs = true;
    extraModulePackages = with kernelPackages; [
      acpi_call
      # exfat-nofuse # Tue 17 Apr 2018 14:59:37 CEST Currently broken, check again with next version
    ];
  };
}
