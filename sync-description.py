#!/usr/bin/env python3

import glob
import urllib.request
import json
import os


req = urllib.request.Request(
    "https://hub.docker.com/v2/users/login",
    data=json.dumps(
        {
            "username": os.getenv("DOCKERHUB_USERNAME"),
            "password": os.getenv("DOCKERHUB_PASSWORD"),
        }
    ).encode(),
    headers={"Content-Type": "application/json"},
)
resp = urllib.request.urlopen(req)
token = json.loads(resp.read())["token"]


for readme in glob.glob("*/README.md"):
    repo = readme[: -len("/README.md")]
    print("Updating description for", repo)
    with open(readme) as f:
        desc = f.read()
    req = urllib.request.Request(
        "https://hub.docker.com/v2/repositories/zhusj/" + repo + "/",
        data=json.dumps(
            {
                "full_description": desc,
            }
        ).encode(),
        headers={"Content-Type": "application/json", "Authorization": "JWT " + token},
        method="PATCH",
    )
    resp = urllib.request.urlopen(req)
    print("Result:", resp.code)

# vim:ai:et:ts=4:sts=4:sw=4:
