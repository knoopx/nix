{pkgs}: let
  pname = "codemapper";
  version = "0-unstable-2026-05-06";

  src = pkgs.fetchFromGitHub {
    owner = "p1rallels";
    repo = "codemapper";
    rev = "689cd0175ad232ec41e2325ace531da4527c8f77";
    sha256 = "sha256-cpor5NxkKpTllYIvghaUnQDQ//7EM3Rh0k05seiWENA=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-vRpWKoVNAwjOu7MarS0aoFoM0TRwSYTd5rrlOaVLWxg=";

    doCheck = false;

    meta = {
      description = "Code intelligence on your CLI for AI agents";
      homepage = "https://github.com/p1rallels/codemapper";
      license = pkgs.lib.licenses.unfree; # No license specified
      maintainers = [];
      mainProgram = "cm";
    };
  }
