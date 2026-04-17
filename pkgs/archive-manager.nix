{
  pkgs,
  lib,
}:
pkgs.runCommand "archive-manager" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "archive-manager";
} ''
  mkdir -p $out/bin
  makeWrapper ${lib.getExe pkgs.file-roller} $out/bin/archive-manager
''
