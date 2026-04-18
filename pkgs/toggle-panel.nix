{pkgs}: let
in
  pkgs.runCommand "toggle-panel" {
    nativeBuildInputs = [pkgs.makeBinaryWrapper];
    meta.mainProgram = "toggle-panel";
  } ''
    mkdir -p $out/bin
    cp ${./toggle-panel.sh} $out/bin/toggle-panel
    chmod +x $out/bin/toggle-panel
  ''
