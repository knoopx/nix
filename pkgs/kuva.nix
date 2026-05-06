{pkgs}: let
  pname = "kuva";
  version = "0.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "Psy-Fer";
    repo = "kuva";
    rev = "v${version}";
    sha256 = "sha256-H7+ZuF3S7eZ9CSQdVY7u6inHsVbDUtYK4GVFOGPYw6E=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    doCheck = false;
    buildFeatures = ["cli" "png"];
    cargoBuildArgs = ["--bin kuva"];
    cargoLock.lockFile = "${src}/Cargo.lock";

    meta = {
      description = "Scientific plotting library in Rust with various backends";
      homepage = "https://github.com/Psy-Fer/kuva";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = "kuva";
    };
  }
