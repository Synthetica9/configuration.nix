# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

hostname: hw-config:

{ config, pkgs, lib, ... }:

let
  machines = import ./machines.nix // {
    # Not a real machine, but used in build_support
    testing = ./testing.nix;
  };

  machine = machines.${hostname};
in {
  networking.hostName = hostname;

  imports =
    [
      hw-config
      machine
      ./users.nix
    ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
}
