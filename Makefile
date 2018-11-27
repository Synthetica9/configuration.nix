.PHONY: test_build activate

activate_path := $(abspath ./activate.nix)
test_path := $(abspath ./test.nix)

test: *.nix Makefile
	@echo $(local_path)
	env NIXOS_CONFIG=$(test_path) nixos-rebuild build

activate:
	env NIXOS_CONFIG=$(local_path) nixos-rebuild switch
