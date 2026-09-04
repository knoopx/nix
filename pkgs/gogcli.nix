{pkgs}: let
  pname = "gogcli";
  version = "0.39.0";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "v${version}";
    hash = "sha256-3A487sebQIEaFleYDte70/c+eeD8gnW8lKk6cg/3JS0=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-C42ehemUTVpFg3cP391/qDYviKqQ3HJgYmfYnbWgA4s=";

    subPackages = ["cmd/gog"];

    buildInputs = [
      pkgs.sqlite
    ];

    nativeBuildInputs = [
      pkgs.pkg-config
    ];

    meta = {
      description = "Google Suite CLI: Gmail, GCal, GDrive, GContacts";
      homepage = "https://github.com/steipete/gogcli";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = "gog";
    };
  }
