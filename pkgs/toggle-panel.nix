{pkgs}:
pkgs.runCommand "toggle-panel" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "toggle-panel";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/toggle-panel \
    --add-flags ${./toggle-panel.nu} \
    --suffix PATH : ${pkgs.nushell}/bin
''