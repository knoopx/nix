{pkgs}: let
  pname = "wacli";
  version = "0.11.2";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "wacli";
    rev = "v${version}";
    hash = "sha256-cGpNZJrmhqIJ77XVHHLXT5uaNud0rowy+gGcf6EcScU=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-LLS2rIQ2y0vlHoq0vRGh+MublJJ3U09RHHb/Y0yfHTA=";

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
