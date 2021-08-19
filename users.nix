{ ... }: {
  users.extraUsers = {
    synthetica = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "wheel"
        "networkmanager"
        "nm-openvpn"
        "tty"
        "dialout" # For arduino
        "davfs2"
        "docker"
        "wireshark"
        "fuse" # for sshfs
        "audio"
        "input" # for libinput-gestures
        "sway"
        "video"
        "libvirtd"
        "vboxuser"
      ];
    };
  };

  nix = { trustedUsers = [ "root" "synthetica" ]; };

  security.pam.loginLimits = [{
    domain = "*";
    type = "hard";
    item = "nofile";
    value = "16384";
  }];

  hardware.opengl = { driSupport = true; };

  # virtualisation.virtualbox.host.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
}
