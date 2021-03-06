{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        import = "exec nix_import";
        nix-shell = "nix-shell --run fish ";
        pandoc = "pandoc --pdf-engine=xelatex";
      };
    };
    thefuck = {
      enable = true;
    };
    mtr.enable = true;
    sway.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bat
    bind
    binutils
    cachix-fix.cachix
    circleci-cli
    cloc
    entr
    exfat
    expect
    file
    flock
    fzf
    ghc
    git
    git-lfs
    gnumake
    gnupg
    nixos-current.imgurbash2
    j
    jq
    lm_sensors
    loc
    micro
    mosh
    ncdu
    nmap
    nox
    optimised.ag
    optimised.htop
    optimised.netcat-gnu
    p7zip
    pacvim
    ripgrep
    rlwrap
    samba
    screen
    sshfs
    sshuttle
    thefuck
    vim
    wget
    python3WithSomePackages
    pandoc
    pandoc-imagine
    haskellPackages.pandoc-citeproc

    qemu
    texlive.combined.scheme-full
  ]
  ++ (with python3Packages; [
    ipython
  ]);
}
