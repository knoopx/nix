{pkgs}: let
  pname = "jj-hunk";
  version = "0.5.0";

  src = pkgs.fetchFromGitHub {
    owner = "laulauland";
    repo = "jj-hunk";
    rev = "v${version}";
    sha256 = "sha256-oUlr2nTMZIMKII3cErRd3dGwHvyDBsjunxymun20i+Y=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-5neR3opBFqU0J5GJDzeujjGquT0tf8uIvmaZtbwUFeo=";

    doCheck = false;

    meta = {
      description = "Programmatic hunk selection for jj (Jujutsu)";
      homepage = "https://github.com/laulauland/jj-hunk";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = "jj-hunk";
    };
  }
