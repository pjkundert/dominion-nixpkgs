let
  srcDef = builtins.fromJSON (builtins.readFile ./nixpkgs.json);
in
builtins.fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/${srcDef.rev}.tar.gz";
  inherit (srcDef) sha256;
}
