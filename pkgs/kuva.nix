{pkgs}: let
  pname = "kuva";
  version = "0.1.6";

  src = pkgs.fetchFromGitHub {
    owner = "Psy-Fer";
    repo = "kuva";
    rev = "v${version}";
    sha256 = "sha256-akhgv7nQUQmrXg0H9BRzHB3joLxZk1hgdL+eWejqXzs=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    doCheck = false;
    buildFeatures = ["cli"];
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
