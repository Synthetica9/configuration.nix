#!/usr/bin/env nix-shell
#!nix-shell -p "python3.withPackages (ps: with ps; [requests])" -i python

import requests
import json
import re
from urllib.parse import urljoin
from datetime import datetime

BASEURL="https://channels.nix.gsc.io/"

http = requests.Session()

def getChannels(URL=BASEURL):
    req = http.get(URL)
    return re.findall(r'href="(nix[\w\d\-\.)]+)/', req.text)


def getJSON(channels, baseURL=BASEURL):
    xs = []
    for channel in channels:
        fullURL = urljoin(baseURL, f'{channel}/latest')
        print(fullURL)
        req = http.get(fullURL)
        commit, timestamp = req.text.split()
        timestamp = int(timestamp)
        date = datetime.utcfromtimestamp(timestamp).date().isoformat()
        d = {'commit': commit, 'name': channel, 'date': date}
        print(d)
        xs.append(d)
    return xs


def main():
    channels = getChannels()
    jsonObj = getJSON(channels)
    with open('./channels/defs.json', 'w') as f:
        json.dump(jsonObj, f, indent=2)
        f.write('\n')  # JSON doesn't insert this automatically


if __name__ == '__main__':
    print('Starting')
    main()
