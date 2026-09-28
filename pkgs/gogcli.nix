{pkgs}: let
  pname = "gogcli";
  version = "0.42.0";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "v${version}";
    hash = "sha256-tCgM4o5wbXVhf8euH6SF8nxRtlCg8ZRKxTW6xpWyYjA=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-TgXyWIfWLAsl0GXaWHgMG+qJQIeTg324sHZrW56nRQA=";

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
