final: previous:

with final;
with lib;

let
  cargo-to-nix = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "cargo-to-nix";
    rev = "ba6adc0a075dfac2234e851b0d4c2511399f2ef0";
    sha256 = "1rcwpaj64fwz1mwvh9ir04a30ssg35ni41ijv9bq942pskagf1gl";
  };

  gitignore = fetchFromGitHub {
    owner = "hercules-ci";
    repo = "gitignore";
    rev = "f9e996052b5af4032fe6150bba4a6fe4f7b9d698";
    sha256 = "0jrh5ghisaqdd0vldbywags20m2cxpkbbk5jjjmwaw0gr8nhsafv";
  };

  nixpkgs-mozilla = fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "7c1e8b1dd6ed0043fb4ee0b12b815256b0b9de6f";
    sha256 = "FMYV6rVtvSIfthgC1sK1xugh3y7muoQcvduMdriz4ag=";
  };

  npm-to-nix = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "npm-to-nix";
    rev = "6d2cbbc9d58566513019ae176bab7c2aeb68efae";
    sha256 = "1wm9f2j8zckqbp1w7rqnbvr8wh6n072vyyzk69sa6756y24sni9a";
  };
in

rec {

  inherit (callPackage cargo-to-nix {})
    buildRustPackage
    cargoToNix
    ;

  inherit (callPackage gitignore {}) gitignoreSource;

  inherit (callPackage npm-to-nix {}) npmToNix;

  inherit (callPackage "${nixpkgs-mozilla}/package-set.nix" {}) rustChannelOf;

  inherit (callPackage ./ezpwd-reed-solomon {}) ezpwd-reed-solomon;

  dominion-hydra = let
    # `final.hydra` comes from the Hydra overlay imported in
    # profiles/logical/holo/hydra/master/upstream.nix
    hydraUnpatched = final.hydra or final.hydra-unstable;
  in hydraUnpatched.overrideAttrs (
    super: {
      doCheck = false;
      patches = [
        # upstreamed: ./hydra/fix-declarative-jobsets-type.patch
        # upstreamed: ./hydra/fix-eval-jobs-build.patch
        ./hydra/logo-vertical-align.diff
        ./hydra/no-restrict-eval.diff
      ];
      meta = super.meta // {
        hydraPlatforms = [ "x86_64-linux" ];
      };
    }
  );

  nodejs = nodejs-12_x;

  zerotierone = previous.zerotierone.overrideAttrs (
    super: {
      meta = with lib; super.meta // {
        platforms = platforms.linux;
        license = licenses.free;
      };
    }
  );

  fpdf2 = with pkgs.python3Packages; buildPythonPackage rec {
    pname = "fpdf2";
    version = "2.5.4";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1zz3xfzqnvfb8474niqwl335s9dmhmihdx394ysy0v5ipb44bc14";
    };
    doCheck = false;
  };
}
