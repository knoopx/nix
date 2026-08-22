{pkgs}: let
  pname = "kuva";
  version = "0.5.0";

  src = pkgs.fetchFromGitHub {
    owner = "Psy-Fer";
    repo = "kuva";
    rev = "v${version}";
    sha256 = "sha256-YxkSmZyIugC0pinxVwaZD+saPSO4e9kp/Eyz1Zeu1zY=";
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
