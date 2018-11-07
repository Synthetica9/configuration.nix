# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

hostname: hw-config:

{ config, pkgs, lib, ... }:

# https://gist.github.com/joepie91/ce9267788fdcb37f5941be5a04fcdd0f#installing-a-few-packages-from-master

let
  machine = {
    AquaRing = {
      arch = "broadwell";
    };
    Will-O-Wisp = {
      arch = "sandybridge";
    };
  }.${hostname};
  nixpkgsRemote = remote: rev: import (builtins.fetchTarball "https://github.com/${remote}/Nixpkgs/archive/${rev}.tar.gz") {
    config = config.nixpkgs.config;
  };

  remotes = lib.mapAttrs (_: nixpkgsRemote) {
    upstream = "nixos";
    devel = "synthetica9";
  };

  master = builtins.trace
    "Warning: master is impure. Using this might have unexpected consequences!"
    (remotes.upstream "master");
  qt510 = pkgs;
  haskell-fix     = remotes.upstream "69fa2d6bfba";
  libreoffice-fix = remotes.upstream "81f5c2698a8";
  /* qt510 = remotes.upstream "4b649a99d84"; */
  steam-fix = remotes.devel "steamRuntimeRefactor";
in
let
  overrideCFlags = pkg: flags:
    pkgs.lib.overrideDerivation pkg (old:
    let
      newflags = pkgs.lib.foldl' (acc: x: "${acc} ${x}") "" flags;
      oldflags = if (pkgs.lib.hasAttr "NIX_CFLAGS_COMPILE" old)
        then "${old.NIX_CFLAGS_COMPILE}"
        else "";
    in
    {
      NIX_CFLAGS_COMPILE = "${oldflags} ${newflags}";
    });
in
let
  optimiseForThisHost = pkg:
    overrideCFlags pkg [ "-O3" "-march=${machine.arch}" "-fPIC" ];

  withDebuggingCompiled = pkg:
    overrideCFlags pkg [ "-DDEBUG" ];
in
let
  terminalPkgs = with pkgs; [
    # mypy
    bat
    bind
    binutils
    circleci-cli
    cloc
    entr
    expect
    file
    flock
    git
    gnumake
    gnupg
    lm_sensors
    loc
    ncdu
    nmap
    nox
    mosh
    optimised.ag
    optimised.htop
    jq
    optimised.netcat-gnu
    p7zip
    rlwrap
    samba
    screen
    sshfs
    sshuttle
    thefuck
    /* xxd */
    vim
    pacvim
    ripgrep
    wget
    exfat
  ] ++ runtimes ++ kernelUtils;

  runtimes = with pkgs; [
    haskell-fix.myGhc
    python3WithSomePackages
    j
    idris
    gcc
    go
    clang
    /* julia */
  ] ++ pyPkgs ++ py2Pkgs ++ hsPkgs;

  kernelUtils = with pkgs; [
    davfs2
    ntfs3g
  ];

  hsPkgs = with pkgs.haskellPackages; [
    hlint
    /* ghc-mod */
    haskell-fix.myGhcMod
    stylish-haskell
  ];

  pyPkgs = with pkgs.python3Packages; [
    ipython
    pycodestyle
    pygments
    spotipy
    scapy
    autopep8
  ];

  py2Pkgs = with pkgs.python2Packages; [
    spotipy
  ];

  goPkgs = with pkgs; [
    golint
    go-langserver
    delve
    go-protobuf
    protobuf
  ];

  typesettingPkgs = with pkgs; [
    pandoc
    texlive.combined.scheme-full
  ];

  desktopPkgs = with pkgs; [
    qt510.albert
    alsaUtils # for amixer
    pavucontrol
    arc-theme
    feh
    fontconfig-ultimate
    gksu
    gnome2.gnome_icon_theme
    gnome3.adwaita-icon-theme
    gnome3.file-roller
    gtk-engine-murrine
    gtk_engines
    gvfs
    i3-wk-switch
    i3lock-color
    kdeFrameworks.networkmanager-qt
    networkmanagerapplet
    notify-desktop
    numix-cursor-theme
    optimised.compton
    playerctl
    redshift
    screenkey
    shutter
    gnome-mpv
    xdotool
    xfce.xfce4notifyd
    xfce.xfce4settings
    xfce.xfce4volumed
    xorg.xbacklight
    xorg.xrefresh
    xss-lock
    rofi
    xclip
    wmfocus
    qbittorrent
  ];

  # Compton can be done via systemd.services

  browsers = with pkgs; [
    /* optimised.firefoxPackages.firefox */
    firefox
    # vivaldi
  ];

  photography = with pkgs; [
    exiftool
    darktable
    gimp
    inkscape
  ];

  graphicalPkgs = with pkgs; [
    dropbox
    libreoffice-fix.libreoffice
    blender
    vscode
    gparted
    keepassxc
    qt510.optimised.lxqt.qterminal
    steam-fix.steam
    steam-fix.steam-run-native
    /* sublime3 */
    syncthing
    virtualbox
    xfce.thunar
    xfce.thunar_volman
    /* zathura */
    spotify
    system-config-printer
    arduino
    # wireshark
    gambatte-speedrun
    vlc
  ] ++ browsers ++ photography;

in {

  imports =
    [ # Include the results of the hardware scan.
      hw-config
      ./xcursor.nix
    ];

  xcursor.theme = "Numix";

  boot = let kernelVersion = pkgs.linuxPackages_latest; in {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };

    tmpOnTmpfs = true;
    kernelPackages = kernelVersion;
    extraModulePackages = with kernelVersion; [
      acpi_call
      /* exfat-nofuse # Tue 17 Apr 2018 14:59:37 CEST Currently broken, check again with next version */
    ];
  };

  # Use the systemd-boot EFI boot loader.
  # boot.extraKernelModules = [ ];

  networking.hostName = hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  # networking.extraHosts = builtins.concatStringsSep "\n"  [
  #   "151.101.1.140 i.redd.it"
  #   "151.101.1.140 redd.it"
  # ];

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_GB.UTF-8";
  };

  systemd.user.services = {
    "albert" = with pkgs; {
      enable = false;
      description = "Albert";
      wantedBy = [ "default.target" ];
      partOf = [ "default.target" ];
      after = [ "xorg.target" ];
      path = [ albert xorg.libxcb] ++ (with qt5; [qtbase qtdeclarative qtsvg qtx11extras]);

      environment = {
        # FOOBAR = system.environment.XDG_DATA_DIRS;
      };

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 2;
        ExecStart = "${pkgs.albert}/bin/albert";
      };
    };

    "auto_brightness" = {
      enable = true;
      description = "Auto brightness adjustment";
      wantedBy = [ "multi-user.target" "sleep.target" ];
      after = [ "supend.target" ];
      path = [ pkgs.python3 pkgs.xorg.xbacklight ];
      environment = {
        PYTHONPATH = "${pkgs.python36Packages.ephem}/lib/python3.6/site-packages/";
      };



      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.python3}/bin/python /home/synthetica/bin/auto_brightness"; # TODO: make this a package?
        User="synthetica";
        # ExecStart = "${pkgs.python3}/bin/python -c 'import sys; print(sys.path)'";
      };
    };

    "xfce4-notifyd" = {
      enable = false;
      description = "Albert";
      wantedBy = [ "default.target" ];
      partOf = [ "default.target" ];
      after = [ "xorg.target" ];
      path = [ pkgs.xfce.xfce4notifyd ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 2;
        ExecStart = "${pkgs.xfce.xfce4notifyd}/bin/xfce4-notifyd";
      };
    };
# [Unit]
# Description=User resume actions
# After=suspend.target

# [Service]
# User=%I
# Type=simple
# ExecStartPre=/usr/local/bin/ssh-connect.sh
# ExecStart=/usr/bin/mysql -e 'slave start'

# [Install]
# WantedBy=suspend.target

  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  services = rec {
  # Enable CUPS to print documents.
    printing.enable = true;
    atd.enable = true;
    # tlp.enable = true;

    resolved.enable = true;
    # Disable DNS caching, re-disable in case of trouble
    nscd.enable = false;

    redshift = {
      enable = true;
      latitude = "52";
      longitude = "5";
      temperature = {
        day = 6500;
        night = 3700;
      };
    };
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e, ctrl:swapcaps";
      # Enable touchpad support.
      libinput = {
        enable = true;
        naturalScrolling = true;
      };

      # displayManager.sddm.enable = true;
      displayManager.lightdm = {
        enable = true;
        background = builtins.fetchurl {
          url = "https://unsplash.com/photos/KqVHRmHVwwM/download?force=true";
          sha256 = "1gk8zd57qi31qpp8kj04hgjwp4mrz5bwfpqxzksfsg6jrrmx22cn";
        };
      };
      # displayManager.gdm.enable = true;
      desktopManager.xterm.enable = false;
      windowManager.i3 = {
        enable = true;
        package = pkgs.optimised.i3-gaps;
      };

      # desktopManager.gnome3 = {
      #   enable = true;
      # };

      desktopManager.xfce = {
        enable = true;
        thunarPlugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar_volman
          thunar-dropbox-plugin
        ];

        # "Don't install XFCE desktop components (xfdesktop, panel and notification
        # daemon).";
        noDesktop = true;
      };
    };

    compton = {
      enable = true;
      inactiveOpacity = "0.90";
      fade = true;
      fadeDelta = 3;
      opacityRules = [
        "50:name = 'i3lock'"
        "99:class_g = 'Firefox'"
        "99:class_g = 'Gnome-mpv'"
      ];
      extraOptions = ''
        # blur-background = true;
        # blur-kern = "5x5gaussian";
        # blur-background-frame = true;
      '';
    };

    gnome3.gvfs.enable=true;
    davfs2.enable=true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers = {
    synthetica = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "wheel" "networkmanager"
        "tty" "dialout" # For arduino
        "davfs2"
        "docker"
        "wireshark"
        "fuse" # for sshfs
        "audio"
      ];
    };

    # wireshark = {
    #   isSystemUser = true;
    # };
  };

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
    wireshark = {
      package = pkgs.wireshark-gtk;
      enable = true;
    };
    /* sway-beta.enable = true; */
  };

  environment = {
    variables = {
      "QT_SCALE_FACTOR" = "1";
      "XCURSOR_THEME" = "numix";
      "EDITOR" = "code --wait";
      "VISUAL" = "code --wait";
      # "XDG_DATA_DIRS" = builtins.concatStringsSep ":" [
      #   "/run/opengl-driver/share"
      #   "/run/opengl-driver-32/share"
      #   "/etc/profiles/per-user/synthetica/share"
      #   "/home/synthetica/.nix-profile/share"
      #   "/nix/var/nix/profiles/default/share"
      #   "/run/current-system/sw/share"
      #  ];
    };
    systemPackages =
      desktopPkgs
      ++ graphicalPkgs
      ++ terminalPkgs
      ++ typesettingPkgs;
  };

  nixpkgs.config = {
    # Cries in spanish
    allowUnfree = true;
    permittedInsecurePackages = [
      "mono-4.0.4.1"
    ];

    packageOverrides = pkgs: rec {
      # Fixes:
      # Don't touch this, things might break :thinking:
      sublime3 = pkgs.sublime3.override {
        gksuSupport = true;
      };

      xfce = pkgs.xfce // {
        gvfs = pkgs.gvfs;
      };

      system-config-printer = pkgs.system-config-printer.overrideAttrs (old : rec {
        pythonPath = with pkgs.pythonPackages; [urllib3] ++ old.pythonPath;
      });

      albert = pkgs.albert.override {
        python3 = pkgs.python3.withPackages (ps: with ps; [ spotipy ]);
      };

      git = pkgs.git.override {
        guiSupport = false;
      };

      gambatte-speedrun = let
        version = "614";
      in pkgs.gambatte.overrideAttrs (old: rec {
        name = "gambatte-speedrun-${version}";
        src = pkgs.fetchFromGitHub {
          owner = "Dabomstew";
          repo = "gambatte-speedrun";
          rev = "r${version}";
          sha256 = "0grbxmmvr6kpxxk4cpmryhacf1b7iy7iydnyni27ybkxs2rayxy0";
        };
        buildInputs =
          with pkgs; [zlib qt5Full scons alsaLib ] ++
          (with xorg; [xlibsWrapper libXrandr libXv]);

        NIX_CFLAGS_COMPILE = ["-DGAMBATTE_QT_VERSION_STR=\"r${version}\""];
      });


      python3WithSomePackages = pkgs.python3.withPackages (ps: with ps; [ scapy ipython hypothesis pyyaml pandas numpy matplotlib ]) ;

      i3lock-color = overrideCFlags pkgs.i3lock-color [ "-fno-sanitize=leak" "-fno-sanitize=address" ];
      # idris = with pkgs.idrisPackages; with-packages [prelude base contrib lightyear];
      myGhc = pkgs.haskellPackages.ghcWithPackages (self : with self; [free megaparsec shelly text]);
      ghc = myGhc;

      myGhcMod = pkgs.haskellPackages.ghc-mod.override {
        ghc = myGhc;
      };

      # Optimization:
      optimised = lib.mapAttrsRecursiveCond (as : as ? "type" -> as.type != "derivation")
        (path: value: builtins.trace "Optimising ${lib.concatStringsSep "." path}" optimiseForThisHost value) pkgs;
      /* optimised = pkgs; */
    };

  };
  # QT4/5 global theme
  environment.etc."xdg/Trolltech.conf" = {
    text = ''
      [Qt]
      style=Arc-Dark
    '';
    mode = "444";
  };

  # GTK2 global theme (widget and icon theme)
  environment.etc."gtk-2.0/gtkrc" = {
    text = ''
      gtk-theme-name="Arc-Dark"
      gtk-icon-theme-name="adwaita"
      gtk-font-name="Sans 10"
      gtk-cursor-theme-name="numix"
    '';
    mode = "444";
  };



  environment.etc."gtk-3.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-theme-name=Adwaita
      gtk-fallback-icon-theme=gnome
      # gtk-toolbar-style=GTK_TOOLBAR_BOTH
      # gtk-font-name=Droid Sans 6
      gtk-application-prefer-dark-theme=1
      gtk-cursor-theme-name=Numix
      # gtk-cursor-theme-size=0
      # gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
      # gtk-button-images=1
      # gtk-menu-images=1
      # gtk-enable-event-sounds=1
      # gtk-enable-input-feedback-sounds=1
      # gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle=hintfull
      gtk-xft-rgba=none
      # gtk-icon-theme-name=Faenza-Ambiance
      # gtk-toolbar-icon-size=GTK_ICON_SIZE_SMALL_TOOLBAR
    '';
    mode = "444";
  };

  security.wrappers = {
    "mount.davfs" = {
      source = "${pkgs.davfs2}/bin/mount.davfs";
      setuid = true;
    };
  };

  security.pam.loginLimits = [
    {
      domain = "*";
      type   = "hard";
      item   = "nofile";
      value  = "16384";
    }
  ];
  security.polkit.enable = true;
  security.sudo.extraConfig = ''
    Defaults    lecture = always
    Defaults    lecture_file = /run/current-system/etc/sudo_lecture
    Defaults    env_reset,pwfeedback
  '';

  environment.etc."sudo_lecture" = {
    text = ''
      [1m     [32m"Bee" careful    [34m__
             [32mwith sudo!    [34m// \
                           \\_/ [33m//
         [35m'''-.._.-'''-.._.. [33m-(||)(')
                           ''''[0m
    '';
    mode = "444";
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  nix.useSandbox = true;
  # nix.package = pkgs.nixUnstable; # Switch to nix beta, if and when needed

  /* nix.buildMachines = [ {
    hostName = "hydropump_build";
    system = "x86_64-linux";
    maxJobs = 8;
    supportedFeatures = [ ];
    mandatoryFeatures = [ ];
  }] ; */
  nix.distributedBuilds = false;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  # https://github.com/dlukes/dotfiles/blob/master/configuration.nix#L323
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts # Microsoft free fonts
      dejavu_fonts
      emojione
      fira-code
      iosevka
      helvetica-neue-lt-std
      powerline-fonts
      ubuntu_font_family
      xorg.fontbhlucidatypewriter100dpi
      font-awesome-ttf
    ];
    fontconfig = {
      defaultFonts.sansSerif = ["Ubuntu"];
      ultimate.enable = true;
    };
  };

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraConfig = ''
      load-module module-switch-on-connect
    '';
  };
  fileSystems."/home/synthetica/stack" = {
    fsType = "davfs";
    device = "https://stack.synthetica.be/remote.php/webdav/";
    noCheck = true; # Sets last flag to 0
    options = [
      "noauto"
      "user"
      "rw"
      "_netdev"
      "uid=synthetica"
    ];
  };

  # virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  # system.stateVersion = "17.09"; # Did you read the comment?
  system.stateVersion = "18.03"; # Did you read the comment?
}
