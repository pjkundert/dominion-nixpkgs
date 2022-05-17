{ pkgs ? import ./. {} }:

with pkgs;

let
  root = toString ./.;

  extraSubstitutors = [
    "https://cache.holo.host"
  ];
  trustedPublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "cache.holo.host-1:lNXIXtJgS9Iuw4Cu6X0HINLu9sTfcjEntnrgwMQIMcE="
    "cache.holo.host-2:ZJCkX3AUYZ8soxTLfTb60g+F3MkWD7hkH9y8CgqwhDQ="
  ];
in

mkShell {
  buildInputs = [
    # additional packages go here
  ];

  shellHook = ''
  '';
  NIX_PATH = builtins.concatStringsSep ":" [
    "cleargrid-nixpkgs=${root}"
    "nixpkgs=${pkgs.path}"
    "nixpkgs-overlays=${root}/overlays"
  ];
}
