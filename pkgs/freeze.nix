{ pkgs, ... }: let
  pname = "freeze";
  version = "0.2.2";

  src = pkgs.fetchFromGitHub {
    owner = "charmbracelet";
    repo = "freeze";
    rev = "v${version}";
    hash = "sha256-1zc62m1uS8Bl6x54SG2///PWfiKbZood6VBibbsFX7I=";
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-BEMVjPexJ3Y4ScXURu7lbbmrrehc6B09kfr03b/SPg8=";

    doCheck = false;

    meta = {
      description = "Generate images of code and terminal output";
      homepage = "https://github.com/charmbracelet/freeze";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = "freeze";
    };
  }
