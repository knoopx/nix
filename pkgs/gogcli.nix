{pkgs}: let
  pname = "gogcli";
  version = "0.39.1";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "v${version}";
    hash = "sha256-217KA+gLC4FwtY+UnV4o6pp4/ZMUfib6jcTtUe7Sjpg=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-GUOGvz6eDApnYxaALAVbHTpqzvIKys+fSpLcrpr2N70=";

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
