{ config, pkgs, ... }:

{
  imports = [ ./workstation ];
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.ports = [ 22 22222 ];
  # services.hydra.enable = true;
  # services.hydra.hydraURL = http://localhost:8080 ;
  # services.hydra.notificationSender = "hydra@hilhorst.be";
  # services.hydra.useSubstitutes = true;
  users.extraUsers.synthetica.openssh.authorizedKeys.keys =
    [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZaNsfqer68KD68f2udjv6BGg66aaIdTFMB50iaYK21 synthetica@AquaRing" ];

  networking.interfaces.eno1.ipv4.addresses = [{
    address = "192.168.1.51";
    prefixLength = 24;
  }];

  networking.defaultGateway = { address = "192.168.1.1"; interface = "eno1"; };
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
}
