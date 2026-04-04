{pkgs}: let
  pname = "jj-hunk";
  version = "0-unstable-2026-04-04";

  src = pkgs.fetchFromGitHub {
    owner = "laulauland";
    repo = "jj-hunk";
    rev = "7e14b879c37ced8497fbf86045be64c2397dda43";
    sha256 = "sha256-B1TMgUFd41fy0+snvkshyAXwwHaD3Fgvdp8E6NWL9AM=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-OtCFmPivmi7nHeqUN+wz++FBMfZ83ZeWW5mM97B7gEY=";

    doCheck = false;

    meta = {
      description = "Programmatic hunk selection for jj (Jujutsu)";
      homepage = "https://github.com/laulauland/jj-hunk";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = "jj-hunk";
    };
  }
