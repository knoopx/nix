{pkgs, ...}: let
  version = "13f3a731405f6ab0dd231ca0d2f11fc896e0eadc";

  src = pkgs.fetchFromGitHub {
    owner = "kooshi";
    repo = "llama-swappo";
    rev = version;
    hash = "sha256-emoXDoVSUtghjgN0h+HlgV6xLKDem3R+iSz2GZx39Tw=";
  };

  ui = pkgs.stdenv.mkDerivation {
    inherit version src;
    pname = "llama-swap-ui";
    outputHash = "sha256-IgA4Pu+0eZbBxMkPWFUN4fUQqTUu76opowMyFCN1s1M=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";

    buildInputs = [pkgs.bun];
    buildPhase = ''
      mkdir -p $out
      cd ui
      bun install
      substituteInPlace vite.config.ts --replace-fail "../proxy/ui_dist" "$out"
      bun node_modules/vite/bin/vite.js build
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
