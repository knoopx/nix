{pkgs}: let
  pname = "jj-hunk";
  version = "0-unstable-2026-02-25";

  src = pkgs.fetchFromGitHub {
    owner = "laulauland";
    repo = "jj-hunk";
    rev = "0b7b04c068a0b7ede9774356771a635283c6caa6";
    sha256 = "0s3mvr8dvipzjdv7xwpgfm3xgy3ifl5a4baykpwc343daclh2z91";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-S8m3+wFebuezIwqW9Lxtd7PcDUfwJu1VeLMjJopqcSE=";

    doCheck = false;

    meta = {
      description = "Programmatic hunk selection for jj (Jujutsu)";
      homepage = "https://github.com/laulauland/jj-hunk";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = "jj-hunk";
    };
  }
