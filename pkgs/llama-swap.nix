{pkgs, ...}: let
  version = "f63b6925e1713efb914ca12c7e011f39ccb137e1";

  src = pkgs.fetchFromGitHub {
    owner = "kooshi";
    repo = "llama-swappo";
    rev = version;
    hash = "sha256-JvyjxZ65+zvFLDXuNUC/r82i/hmvJL2mQDYkhOAo6pE=";
  };

  uiDeps = pkgs.fetchNpmDeps {
    src = src + /ui;
    hash = "sha256-Sbvz3oudMVf+PxOJ6s7LsDaxFwvftNc8ZW5KPpbI/cA=";
  };

  ui = pkgs.stdenv.mkDerivation {
    inherit version src;
    pname = "llama-swap-ui";

    nativeBuildInputs = with pkgs; [
      nodejs
      uiDeps
    ];

    buildPhase = ''
      export npm_config_cache=${uiDeps}
      cd ui
      npm ci --ignore-scripts
      patchShebangs .
      npm rebuild --foreground-scripts
      substituteInPlace vite.config.ts --replace-fail "../proxy/ui_dist" "$out"
      npm run build
    '';
  };
in
  pkgs.buildGoModule {
    inherit version src;
    pname = "llama-swap";
    vendorHash = "sha256-5mmciFAGe8ZEIQvXejhYN+ocJL3wOVwevIieDuokhGU=";
    doCheck = false;
    postPatch = ''
      mkdir -p proxy/ui_dist
      cp -r ${ui}/* proxy/ui_dist
    '';
    meta.mainProgram = "llama-swap";
  }
