{ pkgs, ... }: {
  boot = let
    kernelPackages = pkgs.linuxPackages;
    # boot = let kernelPackages = pkgs.linuxPackages_lqx;
  in {
    inherit kernelPackages;
    tmpOnTmpfs = true;
    extraModulePackages = with kernelPackages;
      [
        acpi_call
        # exfat-nofuse # 2019-07-02 Currently broken, check again with next version
      ];
  };

  # Fixes [FAILED] Failed to mount /tmp
  systemd.additionalUpstreamSystemUnits = [ "tmp.mount" ];
}
