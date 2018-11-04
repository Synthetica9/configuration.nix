let
    hostname = ...
    url = "https://github.com/synthetica9/configuration.nix/archive/master.tar.gz"
in
    (import (builtins.fetchTarball url)) hostname ./hardware-configuration.nix