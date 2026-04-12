{pkgs, ...}: let
  pname = "inspect";
  version = "0.1.1";

  src = pkgs.fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "inspect";
    rev = "v${version}";
    hash = "sha256-pGcE9fnJzgdD38/erHjqHVoBQfGEKxgyN3goUxFFsec=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    subPackages = ["crates/inspect-cli"];

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    buildInputs = with pkgs; [
      openssl
      libgit2
    ];

    cargoHash = "sha256-VETAAv0qR6bArEfVG9N3ICdoSbof8jjX2qPrMPQB/Pk=";
    cargoOpenSSL = false;
    env.OPENSSL_NO_VENDOR = 1;

    postPatch = ''
      # Remove optional openssl-sys dependency
      sed -i "/openssl-sys/d" crates/inspect-cli/Cargo.toml
      sed -i "/vendored-openssl/d" crates/inspect-cli/Cargo.toml
    '';

    doCheck = false;

    meta = {
      description = "Entity-level code review for Git — triage PRs by structural risk, not line count";
      homepage = "https://github.com/Ataraxy-Labs/inspect";
      license = with pkgs.lib.licenses; [asl20];
      maintainers = [];
      mainProgram = "inspect";
    };
  }
