.PHONY: test switch build-vm

build_support = $(abspath ./build_support)
activate_path = $(build_support)/activate.nix
test_path = $(build_support)/test.nix

NIXOS_REBUILD = nixos-rebuild --option tarball-ttl 0 --show-trace

build_all: *.nix Makefile build_support/build_all_machines.py
	# Q: Why python3 foo instead of just ./foo?
	# A: Temporry fix until NixOS/nixpkgs#51681 is solved.
	python3 ./build_support/build_all_machines.py

test: *.nix Makefile
	@echo $(local_path)
	env NIXOS_CONFIG=$(test_path) $(NIXOS_REBUILD) build

switch: *.nix Makefile
	env NIXOS_CONFIG=$(activate_path) $(NIXOS_REBUILD) switch

build-vm: *.nix Makefile
	env NIXOS_CONFIG=$(activate_path) $(NIXOS_REBUILD) build-vm
