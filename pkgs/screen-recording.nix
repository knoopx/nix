{pkgs}:
pkgs.runCommand "screen-recording" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "screen-recording";
} ''
  mkdir -p $out/bin
  cp ${./screen-recording.nu} $out/bin/screen-recording.nu
  chmod +x $out/bin/screen-recording.nu
  makeWrapper $out/bin/screen-recording.nu $out/bin/screen-recording \
    --prefix PATH : ${pkgs.nushell}/bin:${pkgs.gpu-screen-recorder}/bin:${pkgs.libnotify}/bin:${pkgs.xdg-utils}/bin:${pkgs.recording-indicator}/bin
''
