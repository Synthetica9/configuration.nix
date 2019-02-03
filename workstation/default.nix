{ ... }:

{
  imports = [
    ../generic

    ./packages.nix
    ./sudo_lecture.nix
  ];

  security.sudo.extraConfig = ''
    Defaults    env_reset,pwfeedback
  '';
}
