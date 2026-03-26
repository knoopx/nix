{
  pkgs,
  lib,
  ...
}: let
  pname = "gram";
  version = "1.2.0";
in
  pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchurl {
      url = "https://codeberg.org/GramEditor/gram/releases/download/${version}/gram-linux-x86_64-${version}.tar.gz";
      hash = "sha256-LB3XIdyNu8Xd7pcUs9WLll7X60ZeDC7rg6yoWf+OmhA=";
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

      cp -r share/* $out/share/

      # Fix desktop file
      substituteInPlace $out/share/applications/gram.desktop \
        --replace-fail 'TryExec=gram' "TryExec=$out/bin/gram" \
        --replace-fail 'Exec=gram' "Exec=$out/bin/gram"

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
