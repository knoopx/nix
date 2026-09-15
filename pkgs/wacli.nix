{pkgs}: let
  pname = "wacli";
  version = "0.18.2";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "wacli";
    rev = "v${version}";
    hash = "sha256-1czf5PLIdp75P3OrZ5SD9PMeLo7t7MDB+kDvtKsoHZU=";
  };
in
  pkgs.buildGo127Module {
    inherit pname version src;

    vendorHash = "sha256-cRG3t85qMvRNjl6DWGHx2FPfdR8yMpL+PJoMhWy2qbI=";

    subPackages = ["cmd/wacli"];

    tags = ["sqlite_fts5"];

    # Required for GCC 15+ compatibility with sqlite
    CGO_CFLAGS = "-Wno-error=incompatible-pointer-types";

    nativeBuildInputs = [pkgs.pkg-config];

    buildInputs = [pkgs.sqlite];

    meta = {
      description = "WhatsApp CLI - sync, search, send messages via WhatsApp Web protocol";
      homepage = "https://github.com/steipete/wacli";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = "wacli";
    };
  }
