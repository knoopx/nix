{
  pkgs,
  lib,
}:
pkgs.runCommand "browser" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "browser";
} ''
  mkdir -p $out/bin
  makeWrapper ${lib.getExe pkgs.firefox-esr} $out/bin/browser
''
