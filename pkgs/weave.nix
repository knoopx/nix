{pkgs, ...}: let
  pname = "weave";
  version = "0.3.3";

  src = pkgs.fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "weave";
    rev = "v${version}";
    hash = "sha256-GKSINiu98bTYjspHqv/6b7VfCI00gfTkhrmlz0PEKk8=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    subPackages = ["crates/weave-cli" "crates/weave-driver"];

    cargoHash = "sha256-FoewhLvXTZZYEcNlvjfqHMF87WP5Q8OzHmetep+qh/c=";

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
