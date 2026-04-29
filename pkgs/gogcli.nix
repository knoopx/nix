{pkgs}: let
  pname = "gogcli";
  version = "0.14.0";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "v${version}";
    hash = "sha256-aau1w6b4nBdTMUTeX0LwV+8YPP5YeghE0iWSaHQXBFQ=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-UTkuqDXo6TnmZBuk18yhqBTT0+u/CebR4/uZw8XOX2k=";

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
