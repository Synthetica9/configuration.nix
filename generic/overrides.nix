{ ... }:
{
  nixpkgs.config.packageOverrides = pkgs: rec {
    xfce = pkgs.xfce // {
      gvfs = pkgs.gvfs;
    };

    git = pkgs.git.override {
      guiSupport = false;
    };

    python3WithSomePackages = pkgs.python3.withPackages (ps: with ps; [
      scapy
      ipython
      hypothesis
      pyyaml
      # pandas
      numpy
      matplotlib
    ]) ;
  };
}
