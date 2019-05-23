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
    return "nix build --show-trace --keep-going -f <nixpkgs/nixos> -I".split() + [f"nixos-config={configFile}", "system"]


def getMachines():
    output = subprocess.check_output(MACHINES.split())
    return json.loads(output)


def buildMachineByHostName(hostname):
    print(f"Building: {hostname}")
    configFile = os.path.join(f'{BUILD_SUPORT}', f'build-{hostname}.nix')
    with open(configFile, 'w') as f:
        f.write(f'import ../. {json.dumps(hostname)} ./no-hardware.nix')
    buildCommand = getBuildCommand(configFile)
    return subprocess.call(buildCommand)


def main():
    del os.environ['TMPDIR']
    machines = getMachines()
    failed = {hostname for hostname in machines if buildMachineByHostName(hostname) != 0}

    print(f'{len(failed)} failed builds.')
    if failed:
        print(f"{failed} failed")
        exit(1)


if __name__ == '__main__':
    main()
