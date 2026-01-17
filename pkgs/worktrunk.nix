{
  pkgs,
  lib,
  ...
}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "worktrunk";
  version = "0.15.1";

  src = pkgs.fetchFromGitHub {
    owner = "max-sixty";
    repo = "worktrunk";
    rev = "v${version}";
    hash = "sha256-/p3H3q2LgimLi9Ykqsr25d5A4kV1D0vM3ZpL3R/eXQQ=";
  };

  cargoHash = "sha256-60o9JLUSL3B7OpSMWdlsaAr7ZRaAKbAi8C88qMqKE/A=";

  meta = with lib; {
    description = "Worktrunk is a CLI for Git worktree management, designed for parallel AI agent workflows";
    homepage = "https://worktrunk.dev";
    license = with licenses; [mit asl20];
    maintainers = with maintainers; [];
    mainProgram = "wt";
  };
}
