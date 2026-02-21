{pkgs}: let
  pname = "codemapper";
  version = "0-unstable-2026-02-11";

  src = pkgs.fetchFromGitHub {
    owner = "p1rallels";
    repo = "codemapper";
    rev = "c950747dbbba108d21bbc31f5cb11ab2f3b6c1fd";
    sha256 = "sha256-hV4yrgNVDrJf+ZYZOfAsPeLn2xo15j9eYGzy2a4/CvQ=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-SZHWaXYUxF68yQVb7oJV7PLrnqaTyG6ZtJE5WR74Gys=";

    doCheck = false;

    meta = {
      description = "Code intelligence on your CLI for AI agents";
      homepage = "https://github.com/p1rallels/codemapper";
      license = pkgs.lib.licenses.unfree; # No license specified
      maintainers = [];
      mainProgram = "cm";
    };
  }
