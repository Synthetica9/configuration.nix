{ pkgs, ... }:
{
  boot = let kernelVersion = pkgs.linuxPackages; in {
    tmpOnTmpfs = true;
    kernelPackages = kernelVersion;
    extraModulePackages = with kernelVersion; [
      acpi_call
      # exfat-nofuse # Tue 17 Apr 2018 14:59:37 CEST Currently broken, check again with next version
    ];
  };
}
