{ pkgs, ... }: {
  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://hnix.cachix.org"
      "https://nix-linter.cachix.org"
      "https://all-hies.cachix.org"
      "https://tufte-pandoc.cachix.org"
    ];
    binaryCachePublicKeys = [
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
      "hnix.cachix.org-1:8MflOlogfd6Y94rD0cjHsmfK0qIF8F5dPz4TSY7qSdU="
      "nix-linter.cachix.org-1:BdTne5LEHQfIoJh4RsoVdgvqfObpyHO5L0SCjXFShlE"
      "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
      "tufte-pandoc.cachix.org-1:D3q3ErdFi49sYXgVaW3jBzVz//038x8Q8cTNDcx6gcU="
    ];

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    extraOptions = ''
      extra-platforms = aarch64-linux arm-linux
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
    permittedInsecurePackages = [ "python2.7-Pillow-6.2.2" ];
  };

  # nix.package = pkgs.nixUnstable;
}
