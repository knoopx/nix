{pkgs}:
pkgs.runCommand "screen-recording" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "screen-recording";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/screen-recording \
    --add-flags ${./screen-recording.nu} \
    --prefix PATH : ${pkgs.nushell}/bin:${pkgs.gpu-screen-recorder}/bin:${pkgs.libnotify}/bin:${pkgs.xdg-utils}/bin:${pkgs.recording-indicator}/bin
''
