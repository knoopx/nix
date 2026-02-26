{
  pkgs,
  lib,
}:
pkgs.runCommand "editor" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "editor";
} ''
  mkdir -p $out/bin
  makeWrapper ${lib.getExe pkgs.vscode} $out/bin/editor
''
