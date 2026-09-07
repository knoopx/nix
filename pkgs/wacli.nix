{pkgs}: let
  pname = "wacli";
  version = "0.17.2";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "wacli";
    rev = "v${version}";
    hash = "sha256-TP05tkE/bFFZbmOjLyAY2+cpqYwESFBG6Lz/rXhpSCA=";
  };
in
  pkgs.buildGo127Module {
    inherit pname version src;

    vendorHash = "sha256-8Wo54XTj1tLshcAuiStmy+ux8R2tEHUaVSTCZQBMdnE=";

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
