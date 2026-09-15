{pkgs}: let
  pname = "gogcli";
  version = "0.40.0";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "v${version}";
    hash = "sha256-JAIN0MaQegHkg1zBsIYf2YIh3VyeFvQdvyXe9U9AZjg=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-6+/8FVPtrRdE1Hn/MkneZWUiOD/fnQkGYG/T/KD8Du8=";

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
