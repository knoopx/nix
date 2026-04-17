{pkgs}: let
  pname = "nu-jupyter-kernel";
  version = "0.1.15+0.111.0";

  src = pkgs.fetchFromGitHub {
    owner = "cptpiepmatz";
    repo = "nu-jupyter-kernel";
    rev = "nu-jupyter-kernel/v${version}";
    hash = "sha256-hBMmIJYRUs5fDPLYxVhfpiQHShZV4uj/o+DRuQsCIjk=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-GLCK345ADX0YRBpdy0FLonow/9CM2/g/fIJO/lOX3r8=";

    nativeBuildInputs = [pkgs.pkg-config];

    buildInputs = [
      pkgs.fontconfig
    ];

    meta = {
      description = "A Jupyter raw kernel for Nushell";
      homepage = "https://github.com/cptpiepmatz/nu-jupyter-kernel";
      license = pkgs.lib.licenses.mit;
      maintainers = []; # TODO: add your handle
      mainProgram = "nu-jupyter-kernel";
    };
  }
