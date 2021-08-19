.PHONY: test switch build-vm build_all update

build_support = $(abspath ./build_support)
activate_path = $(build_support)/activate.nix
test_path = $(build_support)/test.nix

# NIXOS_REBUILD = nixos-rebuild --option tarball-ttl 0 --show-trace
NIXOS_REBUILD = nixos-rebuild --option tarball-ttl 0 --show-trace -I nixpkgs=https://github.com/nixos/nixpkgs/archive/master.tar.gz
GET_GENERATION:=$(shell readlink /nix/var/nix/profiles/system | grep -o "[0-9]*")

build_all: *.nix Makefile build_support/build_all_machines.py
	./build_support/build_all_machines.py

test: *.nix Makefile
	@echo $(local_path)
	env NIXOS_CONFIG=$(test_path) $(NIXOS_REBUILD) build

switch: *.nix Makefile
	PREV_GENERATION=$(GET_GENERATION)
	env NIXOS_CONFIG=$(activate_path) $(NIXOS_REBUILD) switch
	@echo "Welcome to generation" $(GET_GENERATION)

build: *.nix Makefile
	env NIXOS_CONFIG=$(activate_path) $(NIXOS_REBUILD) build

build-vm: *.nix Makefile
	env NIXOS_CONFIG=$(activate_path) $(NIXOS_REBUILD) build-vm

update: *.nix Makefile
	./channels/update.py
