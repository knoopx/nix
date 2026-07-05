{pkgs, lib, ...}:
pkgs.runCommand "image-viewer" {
  meta.mainProgram = "image-viewer";
  nativeBuildInputs = [pkgs.makeWrapper];
} ''
  makeWrapper ${lib.getExe pkgs.swayimg} $out/bin/image-viewer
''
