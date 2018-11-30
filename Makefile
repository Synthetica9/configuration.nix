.PHONY: test_build activate

build_support = $(abspath ./build_support)
activate_path = $(build_support)/activate.nix
test_path = $(build_support)/test.nix

test: *.nix Makefile
	@echo $(local_path)
	env NIXOS_CONFIG=$(test_path) nixos-rebuild build --show-trace

switch: *.nix Makefile
	env NIXOS_CONFIG=$(activate_path) nixos-rebuild switch

build-vm: *.nix Makefile
	env NIXOS_CONFIG=$(activate_path) nixos-rebuild build-vm
