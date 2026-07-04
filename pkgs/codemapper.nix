{pkgs}: let
  pname = "codemapper";
  version = "0-unstable-2026-05-31";

  src = pkgs.fetchFromGitHub {
    owner = "p1rallels";
    repo = "codemapper";
    rev = "c93ea97a405bf740efb1427deb02bf2a7f279972";
    sha256 = "sha256-i2+lU7mghnDDjAg7GJu8iJXR43Fj3Xvifr3EIQsr95U=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-Tv5392d3JMbldrmCMI+aWpab1x1eHJ15xPtZA/BPJ1w=";

    doCheck = false;

    meta = {
      description = "Code intelligence on your CLI for AI agents";
      homepage = "https://github.com/p1rallels/codemapper";
      license = pkgs.lib.licenses.unfree; # No license specified
      maintainers = [];
      mainProgram = "cm";
    };
  }
