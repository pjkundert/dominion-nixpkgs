#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-git
set -euo pipefail

scriptroot=$(dirname "$(realpath "$0")")

# url encoded: channel_revision{status="stable",variant="primary"}
metric=$(curl --silent --show-error "https://monitoring.nixos.org/prometheus/api/v1/query?query=channel_revision%7Bstatus%3D%22stable%22%2Cvariant%3D%22primary%22%7D" | jq -r .data.result[].metric)
rev=$(jq -r .revision <<<"$metric")
channel=$(jq -r .channel <<<"$metric")

echo "---> Latest stable Nixpkgs channel $channel is at revision $rev"
nix-prefetch-git 'https://github.com/NixOS/nixpkgs.git' --rev "$rev" --quiet > "$scriptroot"/nixpkgs.json
