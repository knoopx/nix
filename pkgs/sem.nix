{pkgs, ...}: let
  pname = "sem";
  version = "0.3.22";

  src = pkgs.fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "sem";
    rev = "v${version}";
    hash = "sha256-maf+Iu0NjJucM+XXUxa66xc3f9rGMQcxA9yEccKoCE0=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    sourceRoot = "${src.name}/crates";

    cargoHash = "sha256-lSDZcJTssVVCKmEnVBrqnqub0iuCmPkiOMGHBXocQKY=";

    nativeBuildInputs = with pkgs; [
      pkg-config
      cmake
    ];

    buildInputs = with pkgs; [
      openssl
      libgit2
      zlib
    ];

    env.OPENSSL_NO_VENDOR = 1;

    doCheck = false;

    meta = {
      description = "Semantic version control CLI — entity-level diff, blame, graph, and impact analysis for code";
      homepage = "https://github.com/Ataraxy-Labs/sem";
      license = with pkgs.lib.licenses; [mit asl20];
      maintainers = [];
      mainProgram = "sem";
    };
  }
