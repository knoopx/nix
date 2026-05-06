{pkgs}: let
  pname = "jj-hunk";
  version = "0-unstable-2026-04-30";

  src = pkgs.fetchFromGitHub {
    owner = "laulauland";
    repo = "jj-hunk";
    rev = "98b8c61e188a660009b2f8990f022e7aaf2e266e";
    sha256 = "sha256-Jwcw5apdRbgpSfCheNdiLWxbnJUCSHeaBXBoCCZCpCU=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-dNVCtZGeusKTyhhvrQOoMPjaQjiysToQAas8PQj9kl8=";

    doCheck = false;

    meta = {
      description = "Programmatic hunk selection for jj (Jujutsu)";
      homepage = "https://github.com/laulauland/jj-hunk";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = "jj-hunk";
    };
  }
