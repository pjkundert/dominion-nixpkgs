{ pkgs ? import ./. {} }:

with pkgs;

let
  root = toString ./.;

  trustedPublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
in

mkShell {
  buildInputs = [
    # additional packages go here
  ];

  shellHook = ''
  '';
  NIX_PATH = builtins.concatStringsSep ":" [
    "dominion-nixpkgs=${root}"
    "nixpkgs=${pkgs.path}"
    "nixpkgs-overlays=${root}/overlays"
  ];
}
