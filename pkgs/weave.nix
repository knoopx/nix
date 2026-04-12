{pkgs, ...}: let
  pname = "weave";
  version = "0.2.8";

  src = pkgs.fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "weave";
    rev = "v${version}";
    hash = "sha256-A9beYK1i52ghb4QQJLp5hw1DeIIc1AiK72oW5D3u08E=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    subPackages = ["crates/weave-cli" "crates/weave-driver"];

    cargoHash = "sha256-C7vJQZ15TE9XwVLi1uCjYdQPr3TDPVEQfOVENeKXg14=";

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
