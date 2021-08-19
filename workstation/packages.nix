{ pkgs, ... }: {
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        import = "exec nix_import";
        nix-shell = "nix-shell --run fish ";
        pandoc = "pandoc --pdf-engine=xelatex";
        code =
          "codium --enable-features=UseOzonePlatform --ozone-platform=wayland";
      };
    };
    thefuck = { enable = true; };
    mtr.enable = true;
    gnupg.agent.enable = true;
  };

  environment.systemPackages = with pkgs;
    [
      bat
      bind
      binutils
      python3Packages.binwalk
      # cachix
      cargo
      circleci-cli
      clang-tools
      cloc
      docker-compose
      entr
      exfat
      expect
      file
      flock
      fzf
      icdiff
      # ghc
      gotop
      git
      git-lfs
      gnumake
      gnupg
      # haskellPackages.pandoc-citeproc
      ipcalc
      imagemagick
      # idris
      # idris2
      # j
      jc
      jq

      librsvg
      lm_sensors
      loc
      magic-wormhole
      micro
      mosh
      multitime
      ncdu
      nixfmt
      # nixos-current.imgurbash2
      nmap
      # nox
      optimised.ag
      htop
      optimised.netcat-gnu
      pacvim
      pinentry_curses
      # pandoc
      # pandoc-imagine
      python3WithSomePackages
      # python3
      ripgrep
      rlwrap
      rls
      gcc
      # sage
      samba
      screen
      sshfs
      speedread
      sshuttle
      swiProlog
      # texlive.combined.scheme-medium
      thefuck
      tig
      vim
      wget
      (perl.withPackages (p: with p; [ Gtk2 ]))
    ] ++ (with python3Packages; [ ipython ]);
}
