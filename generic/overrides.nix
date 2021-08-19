{ lib, config, ... }:

# https://gist.github.com/joepie91/ce9267788fdcb37f5941be5a04fcdd0f#installing-a-few-packages-from-master

let
  nixpkgsRemote = remote: rev:
    import (builtins.fetchTarball
      "https://github.com/${remote}/Nixpkgs/archive/${rev}.tar.gz") {
        config = { allowUnfree = true; };
      };

  remotes = lib.mapAttrs (_: nixpkgsRemote) {
    upstream = "nixos";
    devel = "synthetica9";
  };

  chans = with remotes; {
    # WARNING! Don't name the remote the same as the package you're trying to
    # install, the package will get overridden

    master = builtins.trace
      "Warning: master is impure. Using this might have unexpected consequences!"
      (upstream "master");
    stable = upstream "nixos-20.09";
    pop-init = devel "pop-shell-init";
    albertUpdate = upstream "ece85b6976d0c8924e31f37f81cd91bdf2f3322d";
    plexampUpdate = upstream "3a035feceeda988b41b3f2ba7e97de05e7f75c54";
    sageFix = upstream "da527a0f1c9a91bc28c6dbfd7c06e505547632b7";
    # swayRC = devel "sway-1.16";
    gimpFix = upstream "09bbc0bb1e4e2f9d2f0a0280ea6a59c66223800d";
  };

  applyPR = pkg: prs:
    pkg.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ map (pr:
        builtins.fetchurl "${old.src.meta.homepage}/pull/${toString pr}.patch")
        prs;
    });

in with chans; {
  nixpkgs.config.packageOverrides = pkgs: rec {
    # inherit (sageFix) sage;
    inherit (stable) libreoffice-fresh;
    inherit (master) plexamp;
    # gnomeExtensions = pop-init.gnomeExtensions;

    libtxc_dxtn_s2tc = pkgs.mesa;

    git = pkgs.git.override { guiSupport = false; };

    redshift = pkgs.redshift.overrideAttrs (old: {
      name = old.pname + "wayland-upstream";
      src = builtins.fetchTarball
        "https://github.com/minus7/redshift/archive/wayland.tar.gz";
    });

    # waybar = applyPR pkgs.waybar [
    #   # Add option to rewrite sway/window title
    #   1055
    #   # rewriteTitle: allow multiple sequential rewrites
    #   1087
    # ];
    sway-unwrapped = applyPR pkgs.sway-unwrapped [
      # Add tab dragging functionality
      6219
    ];

    python3WithSomePackages = pkgs.python3.withPackages (ps:
      with ps; [
        scapy
        i3ipc
        psutil
        ipython
        hypothesis
        pyyaml
        pandas
        numpy
        pylint
        flake8
        autopep8
        networkx
        matplotlib
        tqdm
      ]);

    # xfce4-13 = pkgs.xfce;
    xfce = pkgs.xfce // {
      gtk-xfce-engine = pkgs.hello;
      xfce4-mixer = pkgs.hello;
    };

    # nixos-hardware = builtins.fetchTarball "https://github.com/NixOS/nixos-hardware/archive/master.tar.gz";
  };

}
