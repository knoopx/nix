{pkgs}: let
  pname = "wacli";
  version = "0.17.1";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "wacli";
    rev = "v${version}";
    hash = "sha256-i7hZxLQkde4fzoFS7977gLFxoCsAVnmgdyqtBITHTxM=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-Ymm/hn1xvMA9MnAtSQxMWoPDx5qNFv9bHR9D6031upI=";

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
