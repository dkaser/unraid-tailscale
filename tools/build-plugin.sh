#!/bin/sh

FILENAME=tailscale; jinja -d plugin/tailscale.json -D filename $FILENAME -D branch main plugin/tailscale.j2 > ../plugin/$FILENAME.plg
FILENAME=tailscale-trunk; jinja -d plugin/tailscale.json -D filename $FILENAME -D branch trunk plugin/tailscale.j2 > ../plugin/$FILENAME.plg