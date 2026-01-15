{pkgs}: let
  pname = "codemapper";
  version = "0-unstable-2026-01-15";

  src = pkgs.fetchFromGitHub {
    owner = "p1rallels";
    repo = "codemapper";
    rev = "de91359f35eecedf4772524f9bb60bd8950ca75e";
    sha256 = "sha256-/0CRfsFJ04nO7aYkEJ+9wQ2M3lz5XS/nU7pk82dLWZA=";
  };
in
pkgs.rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-pAqbFw0obpxcATPIBvrZtZrcBAak1xreaE8X9+nYnrU=";

  meta = {
    description = "Code intelligence on your CLI for AI agents";
    homepage = "https://github.com/p1rallels/codemapper";
    license = pkgs.lib.licenses.unfree; # No license specified
    maintainers = [];
    mainProgram = "cm";
  };
}