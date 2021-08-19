#!/usr/bin/env nix-shell
#!nix-shell -p "python3.withPackages (ps: with ps; [requests])" -i python

import requests
import json
import re
from urllib.parse import urljoin
from datetime import datetime
import sys

BASEURL="https://channels.nix.gsc.io/"
FILENAME='./channels/defs.json'

http = requests.Session()

def oldJSON(filename=FILENAME):
    with open(filename, 'r') as f:
        return json.load(f)

def getChannels(URL=BASEURL):
    req = http.get(URL)
    res = re.findall(r'\<h3 class="channel__header"\>(nix[\w\d\-\.)]+)\<\/h3\>', req.text)
    assert len(res) >= 0
    return res


def getJSON(channels, old=None, baseURL=BASEURL):
    xs = []
    old = {x['name']: x for x in old}
    for channel in channels:
        fullURL = urljoin(baseURL, f'{channel}/latest')
        # print(fullURL)
        req = http.get(fullURL)
        commit, timestamp = req.text.split()
        timestamp = int(timestamp)
        date = datetime.utcfromtimestamp(timestamp).date().isoformat()
        d = {'commit': commit, 'name': channel, 'date': date}
        if old is not None:
            o = old.get(channel)
            if o is None:
                print(f'{channel}: init at {commit} ({date})')
            elif commit != o['commit']:
                print(f'{channel}: {o["commit"][:8]} ({o["date"]}) -> {commit[:8]} ({date})')
        else:
            print(d)
        xs.append(d)
    return xs


def main():
    channels = getChannels()
    old = oldJSON()
    jsonObj = getJSON(channels, old=old)
    if jsonObj == old:
        sys.stderr.write('Already up to date.\n')
        return 1
    with open(FILENAME, 'w') as f:
        json.dump(jsonObj, f, indent=2)
        f.write('\n')  # JSON doesn't insert this automatically
    return 0

if __name__ == '__main__':
    print('Starting')
    sys.exit(main())
