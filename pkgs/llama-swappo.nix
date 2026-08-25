{ pkgs, ... }:
let
  pname = "llama-swappo";
  # No release tags exist for this fork; pinned to a commit on `main`.
  # (Latest main commit: b74e2ea "add ollama api (squashed for maintenance)".)
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "kooshi";
    repo = "llama-swappo";
    rev = "b74e2ea63417dd857bef90f03d96d4a9a187f640";
    hash = "sha256-Jbdv7fzUqQz1vn5atSBBsUHTM/xxxDbv+JFV7ykgeT8=";
  };
in
pkgs.buildGoLatestModule rec {
  inherit pname version src;

  vendorHash = "sha256-sf3VZ9vJaO8LMrUgWBvw7xfywpzBolLdVb4oMF0nbT8=";

  # Upstream goreleaser builds with CGO_ENABLED=0; modernc.org/sqlite is pure-Go.
  env = { CGO_ENABLED = "0"; };

  # The main package is the `llama-swap` binary at the repo root.
  binaryName = "llama-swap";

  # The web UI is optional behind the `embed_ui` build tag (needs node/npm).
  # Build WITHOUT it so this is a "minimal" replacement for llama-swap-minimal.
  doCheck = false;

  meta = {
    description = "llama-swap with a minimal Ollama-compatible API";
    homepage = "https://github.com/kooshi/llama-swappo";
    license = pkgs.lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "llama-swap";
  };
}
