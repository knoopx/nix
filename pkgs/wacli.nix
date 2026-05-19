{pkgs}: let
  pname = "wacli";
  version = "0.11.0";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "wacli";
    rev = "v${version}";
    hash = "sha256-93D8IyfmJIi2URZriG6lP/fqFE59REwglxg7m013Eug=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-N5VIGCfMuaMbSuxwQLXUOCBGJ23WM4+3UA6vZhvxOPs=";

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
