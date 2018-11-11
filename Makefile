.PHONY: test_build ENV

local_path := $(abspath ./local.nix)

test_build: *.nix Makefile ENV

ENV:
	@echo $(local_path)
	env NIXOS_CONFIG=$(local_path) nixos-rebuild build
