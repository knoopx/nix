{pkgs}: let
  pname = "codemapper";
  version = "0-unstable-2026-04-04";

  src = pkgs.fetchFromGitHub {
    owner = "p1rallels";
    repo = "codemapper";
    rev = "37256f4384403a02088eb2bd2a60be507eeb3d4b";
    sha256 = "sha256-k30hVLnM8oUWF8XdL65v1DwJTLhmiZc9k8yWpNvxtV0=";
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
