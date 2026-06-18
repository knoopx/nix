{pkgs, ...}: let
  pname = "weave";
  version = "0.3.6";

  src = pkgs.fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "weave";
    rev = "v${version}";
    hash = "sha256-VlJUXAXlWpFGlJgAEhhdeX35AZV/G/IJlXEjU/7SfJg=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    subPackages = ["crates/weave-cli" "crates/weave-driver"];

    cargoHash = "sha256-ZPe9l3S88idwYrayT5mmagW/VdA0VlUHTDXVyHoOF1w=";

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    buildInputs = with pkgs; [
      openssl
    ];

    env.OPENSSL_NO_VENDOR = 1;

    doCheck = false;

    meta = {
      description = "Entity-level semantic merge driver for Git — resolves merge conflicts at the function/class level instead of lines";
      homepage = "https://github.com/Ataraxy-Labs/weave";
      license = with pkgs.lib.licenses; [mit asl20];
      maintainers = [];
      mainProgram = "weave";
    };
  }
