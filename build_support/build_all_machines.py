#! /usr/bin/env nix-shell
#! nix-shell -i python -p python3

import subprocess
import json
from pprint import pprint
import tempfile
import os


MACHINES = 'nix-instantiate --json --eval ./machines.nix'
BUILD_SUPORT = "./build_support/"


def getBuildCommand(configFile):
    return "nix build -f <nixpkgs/nixos> -I".split() + [f"nixos-config={configFile}", "system"]


def getMachines():
    output = subprocess.check_output(MACHINES.split())
    return json.loads(output)


def buildMachineByHostName(hostname):
    print(f"Building: {hostname}")
    configFile = f'{BUILD_SUPORT}/build-{hostname}.nix'
    with open(configFile, 'w') as f:
        f.write(f'import ../. {json.dumps(hostname)} ./no-hardware.nix')
    buildCommand = getBuildCommand(configFile)
    subprocess.check_call(buildCommand)


def main():
    machines = getMachines()
    for hostname in machines:
        buildMachineByHostName(hostname)


if __name__ == '__main__':
    main()
