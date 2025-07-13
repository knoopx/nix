{pkgs, ...}: let
  version = "fff572a8da24bebd2f59ee7ef97d10f8796ca6dc";

  src = pkgs.fetchFromGitHub {
    owner = "kooshi";
    repo = "llama-swappo";
    rev = version;
    hash = "sha256-SDcUGkm5PEplBlCIYASj9jon5uWYOw2rfzjbFkT2bwc=";
  };

  ui = pkgs.stdenv.mkDerivation {
    inherit version src;
    pname = "llama-swap-ui";
    outputHash = "sha256-yb4W+qak1WlOXw9Jm47eD1inPNEHwZC2oZxajCaLgZ0=";
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
    vendorHash = "sha256-nSdvqYVBBVIdoa991bLVwfHPGAO4OHzW8lEQPQ6cuMs=";
    doCheck = false;
    postPatch = ''
      mkdir -p proxy/ui_dist
      cp -r ${ui}/* proxy/ui_dist
    '';
    meta.mainProgram = "llama-swap";
  }
