{pkgs}:
pkgs.runCommand "window-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  runtimeInputs = [pkgs.nushell pkgs.niri pkgs.ffmpeg];
  meta.mainProgram = "window-control";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/window-control \
    --add-flags ${./window-control.nu} \
    --suffix PATH : ${pkgs.niri}/bin:${pkgs.nushell}/bin:${pkgs.ffmpeg}/bin
''
