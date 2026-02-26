{
  pkgs,
  lib,
}:
pkgs.runCommand "image-viewer" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "image-viewer";
} ''
  mkdir -p $out/bin
  makeWrapper ${lib.getExe pkgs.eog} $out/bin/image-viewer
''
