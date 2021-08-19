{ ... }:

{
  imports = [
    ../generic

    #    ./hie.nix
    ./packages.nix
    ./sudo_lecture.nix
    ./typesetting.nix
  ];

  security.sudo.extraConfig = ''
    Defaults    env_reset,pwfeedback
  '';

  # qemu-user.arm = true;

  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
