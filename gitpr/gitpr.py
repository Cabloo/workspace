#!/usr/bin/python

import requests
import json
import sys

access_token = "your_github_access_token"

head = sys.argv[1]
branch = sys.argv[2]
commit = sys.argv[3]
repo = sys.argv[4]
target_branch = 'dev' if repo == 'Cabloo/some_repo_that_uses_dev_branch' else 'master'

data = json.dumps({
    'title': commit,
    'head': "{0}:{1}".format(head[:head.find("/")], branch),
    'base': target_branch,
})
headers = {
    'Accept': 'application/vnd.github.v3+json',
    'Content-Type': 'application/json',
}

url = "https://api.github.com/repos/{0}/pulls?access_token={1}"
resp = requests.post(url.format(repo, access_token), data=data)
info = json.loads(resp.text)
if 'errors' in info and len(info['errors']) > 0:
    for error in info['errors']:
        print "ERROR: {0}".format(error['code'])
elif '_links' in info:
    link = info['_links']['html']['href']
    print "Pull Request Created: %s" % info['_links']['html']['href']

    try:
        import pyperclip
        pyperclip.copy(link)
        print "Link copied to clipboard."
    except ImportError:
        print ("Could not copy link to clipboard. Please install pyperclip with"
                "(sudo) pip install pyperclip.")
else:
    print "Couldn't find link in output. Perhaps it is malformed?"
    print resp.text
