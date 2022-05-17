{ pkgs }:

with pkgs;

let
  inherit (rust.packages.stable) rustPlatform;
  inherit (darwin.apple_sdk.frameworks) Security;
  stdenv = pkgs.gcc11Stdenv;
in

{
  ezpwd-reed-solomon = stdenv.mkDerivation rec {
    name = "ezpwd-reed-solomon";
    src = fetchFromGitHub {
      owner = "pjkundert";
      repo = "ezpwd-reed-solomon";
      rev = "01fbdd537b3dbd5797c8ff17e070862a5e6a6446";  # master 2022-05-13
      fetchSubmodules = true;
      sha256 = "0xmv54l7kbmh5k9c3dq2y3vrcml0iyfv9sibb50l0kis1qily0nc";
    };

    nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.isDarwin [
      xcbuild
    ];

    buildInputs = [
      git
      perl
      bash
      boost
    ];

    buildPhase = ''
      make libraries # only need the includes/libraries; don't run tests...
    '';

    installPhase = ''
      mkdir -p          $out/include
      cp -RL c++/*      $out/include
      mkdir -p          $out/lib
      mv libezpwd-*     $out/lib
    '';
  };
}
