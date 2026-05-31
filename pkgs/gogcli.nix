{pkgs}: let
  pname = "gogcli";
  version = "0.20.0";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "v${version}";
    hash = "sha256-ntJn0TTtnNeIPX4ZQQ4Zb0SJzqkjnJHoFzVpO2wHfZk=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-fkvMTJmYRsknDDffrZq2L2GRYDozwPX0yv7K84n5a84=";

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
