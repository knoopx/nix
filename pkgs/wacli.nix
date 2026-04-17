{pkgs}: let
  pname = "wacli";
  version = "0.6.0";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "wacli";
    rev = "v${version}";
    hash = "sha256-qEEiqX0r6iIm5STYxpaHuXdbtaQKigSGD8jLECbsW/0=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-A5XDBUYHsNVnIJ5TBt8ePSY5oWlyjsYxp6u9169vy9I=";

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
