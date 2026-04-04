{
  pkgs,
  lib,
  ...
}: let
  pname = "gram";
  version = "1.2.1";
in
  pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchurl {
      url = "https://codeberg.org/GramEditor/gram/releases/download/${version}/gram-linux-x86_64-${version}.tar.gz";
      hash = "sha256-KNFiOjLI2Z/klHVOsap7NNZpBOebwZp/oux3LDq69F8=";
    };

    sourceRoot = "gram.app";

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      makeBinaryWrapper
    ];

    buildInputs = with pkgs; [
      libgcc.lib
      vulkan-loader
      zlib
      libx11
      libxcb
      libxau
      libxdmcp
      libxkbcommon
    ];

    runtimeDependencies = [
      pkgs.vulkan-loader
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/libexec $out/lib $out/share

      cp libexec/gram-editor $out/libexec/
      cp lib/* $out/lib/

      # The CLI binary expects ../libexec/gram-editor relative to itself
      cp bin/gram $out/bin/gram

      # Copy icons with proper directory structure
      cp -r share/icons $out/share/

      # Copy desktop files
      cp -r share/applications $out/share/

      runHook postInstall
    '';

    meta = {
      description = "The Gram Code Editor";
      homepage = "https://codeberg.org/GramEditor/gram";
      license = lib.licenses.gpl3Only;
      mainProgram = "gram";
      platforms = ["x86_64-linux"];
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    };
  }
