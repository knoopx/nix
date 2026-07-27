{pkgs}: let
  pname = "gogcli";
  version = "0.34.1";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "v${version}";
    hash = "sha256-ocC+A63GLrZQA3mXEPjIfsM7Af9NiYjGF8DZI/2yNS0=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-MAbbCLdoOLWer7HO3+RZJuN10gLeTgN6/CbNn6pzGwQ=";

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
