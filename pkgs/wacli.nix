{pkgs}: let
  pname = "wacli";
  version = "0.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "wacli";
    rev = "v${version}";
    hash = "sha256-tJ5d33VVW5aYvacHJEVm8cVKVtpdWCIOdHNy2WTR4Cg=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-0mHZjZHQBHTlPzVT4ScyRBSaQ4Z8FEm2GFfsPF6Tjrw=";

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
