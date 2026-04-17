{
  pkgs,
  lib,
}:
pkgs.runCommand "pdf-viewer" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "pdf-viewer";
} ''
  mkdir -p $out/bin
  makeWrapper ${lib.getExe pkgs.evince} $out/bin/pdf-viewer
''
