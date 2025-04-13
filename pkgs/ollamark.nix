{
  pkgs,
  lib,
  ...
}: let
  pkg = pkgs.stdenvNoCC.mkDerivation {
    name = "ollamark";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-pa/8yhFooTA+LUrkz96qD4uHcN4Oa1H+tAjbPr1Nnh8=";

    nativeBuildInputs = [pkgs.installShellFiles];

    src = pkgs.fetchFromGitHub {
      owner = "knoopx";
      repo = "ollamark";
      rev = "651970714697f4b90ec341c15607ae1662eaea59";
      sha256 = "sha256-f/iCXaHDfgvOYIpmb0RMwAI3WAEhtj88j5yfLfzCo+k=";
    };

    buildPhase = ''
      ${lib.getExe pkgs.bun} install
      mkdir -p $out/share/ollamark
      cp -r . $out/share/ollamark
    '';

    postInstall = ''
      installShellCompletion share/completions/ollamark.fish
    '';
  };

  wrapper =
    pkgs.writeShellApplication
    {
      name = "ollamark";
      text = ''
        ${lib.getExe pkgs.bun} "${pkg}/share/ollamark/src/ollamark.tsx" "$@"
      '';
    };
in
  pkgs.symlinkJoin {
    name = "ollamark";
    paths = [
      wrapper
      pkg
    ];
  }
