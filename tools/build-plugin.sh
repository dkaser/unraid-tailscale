#!/bin/sh

jinja -d plugin/tailscale.json -D branch main plugin/tailscale.j2 > ../plugin/tailscale.plg
jinja -d plugin/tailscale.json -D branch trunk plugin/tailscale.j2 > ../plugin/tailscale-trunk.plg