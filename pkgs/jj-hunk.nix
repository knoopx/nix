{pkgs}: let
  pname = "jj-hunk";
  version = "0-unstable-2026-05-17";

  src = pkgs.fetchFromGitHub {
    owner = "laulauland";
    repo = "jj-hunk";
    rev = "3643ee8f7fa02f0ea4befd060e0e1057df72b987";
    sha256 = "sha256-lFuYTg6TW/Lsz4wwaaWFi37F2aGKpLwQgq40VTdDUKE=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-7yCA4a2NM20o7z757lbMtyvFC+72ScTd+N7AKWCH1KU=";

    doCheck = false;

    meta = {
      description = "Programmatic hunk selection for jj (Jujutsu)";
      homepage = "https://github.com/laulauland/jj-hunk";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = "jj-hunk";
    };
  }
