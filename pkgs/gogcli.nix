{pkgs}: let
  pname = "gogcli";
  version = "0.28.0";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "v${version}";
    hash = "sha256-qXeRxZQkDwVRuXWkAPI3Yr1pQpZmmVX2SQS8UdBQGYo=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-JrRIUYpw2lAD0ezi0HTZvS42OS7vP8DAHU3m0u3eCbM=";

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
