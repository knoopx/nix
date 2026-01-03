{pkgs}: let
  pname = "guitar";
  version = "0.1.1";

  src = pkgs.fetchFromGitHub {
    owner = "asinglebit";
    repo = "guitar";
    rev = "v${version}";
    sha256 = "b7YFWO73Hhq9vHYQ/nP1hrqJ3FlpN57J6enc2qMNOAU=";
  };
in
pkgs.rustPlatform.buildRustPackage {
  inherit pname version src;

  nativeBuildInputs = [pkgs.pkg-config];

  buildInputs = [pkgs.openssl];

  cargoHash = "sha256-prvIkw9jjzF+4jLLfhELnHR0hzyZ1Bmza1SFFbJv8H8=";

  meta = {
    description = "An unofficial GitHub CLI extension for managing pull requests";
    homepage = "https://github.com/asinglebit/guitar";
    license = pkgs.lib.licenses.mit;
    maintainers = [];
  };
}
