{pkgs}: let
  pname = "wacli";
  version = "0.5.0";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "wacli";
    rev = "v${version}";
    hash = "sha256-iDpkwn2LK99+VT0spa9O3HOPrprWBIYbNAp0HuAUxaY=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-/nz61Inm4rF5H4u16607wmER+Wp651gc7u/FFFIX9wo=";

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
