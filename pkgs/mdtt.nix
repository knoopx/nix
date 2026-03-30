{pkgs}: let
  pname = "mdtt";
  version = "0.3.1";

  src = pkgs.fetchFromGitHub {
    owner = "szktkfm";
    repo = "mdtt";
    rev = "v${version}";
    hash = "sha256-loskhq9hMs86JQx8niuBSMhjuJpowMRckwD7sDNFBOs=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-sEdDfQnBaqQ/pBubYT0sWMaC3tyi0g/dIfUsrHYrA+Q=";

    subPackages = ["cmd/mdtt"];

    meta = {
      description = "Markdown table editor TUI";
      homepage = "https://github.com/szktkfm/mdtt";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = "mdtt";
    };
  }
