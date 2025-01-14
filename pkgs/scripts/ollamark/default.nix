{
  pkgs,
  lib,
  ...
}: let
  pkg = pkgs.stdenvNoCC.mkDerivation {
    name = "ollamark";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-PEGU8crrtK8RDpICJjT0U6w1KSVJsp6YcBQt4n4TuKE=";

    src = pkgs.fetchFromGitHub {
      owner = "knoopx";
      repo = "ollamark";
      rev = "72b97f00fb0dc6656ec35f4a2eeac45dbefb70e0";
      sha256 = "sha256-SvzSI/hcbn2WCXhCG3Dyc9Pa+vM+16MUGue+ueZ8Uzg=";
    };

    buildPhase = ''
      ${lib.getExe pkgs.bun} install
      cp -r . $out
    '';
  };
in
  pkgs.writeShellApplication {
    name = "ollamark";
    text = ''
      ${lib.getExe pkgs.bun} "${pkg}/src/ollamark.tsx" "$@"
    '';
  }
