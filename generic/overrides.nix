{ ... }:
{
  nixpkgs.config.packageOverrides = pkgs: rec {
    xfce = pkgs.xfce // {
      gvfs = pkgs.gvfs;
    };

    git = pkgs.git.override {
      guiSupport = false;
    };

    sway = pkgs.sway.overrideAttrs (oldAttrs: rec {
      patches = oldAttrs.patches ++ [
        (pkgs.fetchpatch {
          url = https://github.com/swaywm/sway/pull/3962.patch;
          sha256 = "1509gaplbghsgw6g9v9x088jl84195cjyjyy7cyz2cjh3yqa1g8s";
        })
      ];
    });

    python3WithSomePackages = pkgs.python3.withPackages (ps: with ps; [
      scapy
      (i3ipc.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "acrisci";
          repo = "i3ipc-python";
          rev = "243d353434cdd2a93a9ca917c6bbf07b865c39af";
          sha256 = "0lhiiccz7wsnxhyb2p87n77pkdpk1ani90x1zkcgk9gs99nl0sml";
        };
      }))
      psutil
      ipython
      hypothesis
      pyyaml
      # pandas
      numpy
      pylint
      flake8
      autopep8
      matplotlib
    ]);

    redshift = pkgs.redshift.overrideAttrs (oldAttrs: rec {
      src = pkgs.fetchFromGitHub {
        owner = "breznak";
        repo = "redshift";
        rev = "Lourens-Rich-master";
        sha256 = "1b9gjz1crw8fzlpdisafn6lx37m5dg7s1ak35qcrgzgqlcsldw1l";
      };
    });

    konsole = pkgs.konsole.overrideAttrs (oldAttrs: rec {
      postInstall = oldAttrs.postInstall + ''

        wrapProgram $out/bin/konsole \
          --set QT_QPA_PLATFORM "wayland;xkb" \
          --set QT_WAYLAND_DISABLE_WINDOWDECORATION 1
      '';
    });

    mako = pkgs.mako.overrideAttrs (oldAttrs: rec {
      patches = pkgs.fetchpatch {
        url = https://github.com/emersion/mako/pull/147.patch;
        sha256 = "0yzvzq6skspmik5ql8paydcm9wgb6lpnsabfqvnnjs3f586pkbin";
      };
    });
  };
}
