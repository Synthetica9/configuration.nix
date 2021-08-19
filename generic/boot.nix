{ ... }: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };

    # crashDump.enable = true;
    plymouth.enable = true;
  };
}
