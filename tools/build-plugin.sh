#!/bin/sh

FILENAME=tailscale; jinja -d plugin/tailscale.json -D filename $FILENAME -D branch main plugin/tailscale.j2 > ../plugin/$FILENAME.plg
FILENAME=prerelease/tailscale; jinja -d plugin/tailscale.json -D filename $FILENAME -D branch prerelease plugin/tailscale.j2 > ../plugin/$FILENAME.plg
FILENAME=trunk/tailscale; jinja -d plugin/tailscale.json -D filename $FILENAME -D branch trunk plugin/tailscale.j2 > ../plugin/$FILENAME.plg