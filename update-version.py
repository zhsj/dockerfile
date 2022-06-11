#!/usr/bin/env python3

import fileinput
import glob
import json
import re
import urllib.request


def github_latest(repo):
    resp = urllib.request.urlopen(
        "https://api.github.com/repos/" + repo + "/releases/latest"
    )
    release = json.loads(resp.read())
    return release["tag_name"]


def generic_latest(url, pattern):
    resp = urllib.request.urlopen(url)
    content = resp.read().decode()
    versions = pattern.findall(content)
    return versions[-1]


versions = [
    (
        re.compile("(DOCKER_VERSION=)[\d.]+"),
        r"\g<1>" + github_latest("moby/moby").removeprefix("v"),
    ),
    (
        re.compile("(RUNNER_VERSION=)[\d.]+"),
        r"\g<1>" + github_latest("actions/runner").removeprefix("v"),
    ),
    (
        re.compile("(BIND_VERSION=)[\d.]+"),
        r"\g<1>"
        + generic_latest("https://ftp.isc.org/isc/bind9/", re.compile("9\.16\.\d+")),
    ),
]

with fileinput.input(files=glob.glob("*/Dockerfile"), inplace=True) as f:
    for line in f:
        for version in versions:
            line = version[0].sub(version[1], line)
        print(line, end="")

# vim:ai:et:ts=4:sts=4:sw=4:
