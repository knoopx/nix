{pkgs}: let
  pname = "gogcli";
  version = "0.13.0";

  src = pkgs.fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "v${version}";
    hash = "sha256-UN1dW3VX7N3fymn8y40Xd0sIznihjeeLtb1nHOEMDcY=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-BNVY9Wx+bQA/hxT0tHo5anBSNnMHSLWs9cedoaMhQTc=";

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
