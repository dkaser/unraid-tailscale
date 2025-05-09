#!/bin/sh

FILENAME=tailscale; jinja -d plugin/tailscale.json -D filename $FILENAME -D branch main -D githubRepository "$GITHUB_REPOSITORY" plugin/tailscale.j2 > ../plugin/$FILENAME.plg
FILENAME=tailscale-preview; jinja -d plugin/tailscale.json -D filename $FILENAME -D branch preview -D githubRepository "$GITHUB_REPOSITORY" plugin/tailscale.j2 > ../plugin/$FILENAME.plg
FILENAME=tailscale-trunk; jinja -d plugin/tailscale.json -D filename $FILENAME -D branch trunk -D githubRepository "$GITHUB_REPOSITORY" plugin/tailscale.j2 > ../plugin/$FILENAME.plg