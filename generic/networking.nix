{ ... }:

{
  networking.networkmanager.enable = true;
  services = {
    resolved.enable = true;
    # Disable DNS caching, re-disable in case of trouble
    nscd.enable = false;
  };
}
