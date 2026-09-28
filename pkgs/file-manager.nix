{
  pkgs,
  lib,
}:
pkgs.runCommand "file-manager" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  runtimeInputs = [pkgs.nautilus];
  meta.mainProgram = "file-manager";
} ''
  mkdir -p $out/bin
  makeWrapper ${lib.getExe pkgs.nautilus} $out/bin/file-manager
''
