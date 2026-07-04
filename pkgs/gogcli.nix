{pkgs}: let
  pname = "gogcli";
  version = "0.32.0";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "v${version}";
    hash = "sha256-Cg2UAS2qPhMT1MklLGIXk4x+6dIwIeKypFtpZsj+ddw=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-fof2DVm6Cn1ZW7gKSYLHX6M6nPbtYBn6EKinptjhhrE=";

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
