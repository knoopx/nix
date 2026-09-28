{pkgs}:
pkgs.runCommand "screen-recording" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  runtimeInputs = [pkgs.nushell pkgs.gpu-screen-recorder pkgs.libnotify pkgs.xdg-utils pkgs.recording-indicator pkgs.dbus];
  meta.mainProgram = "screen-recording";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/screen-recording \
    --add-flags ${./screen-recording.nu} \
    --prefix PATH : ${pkgs.nushell}/bin:${pkgs.gpu-screen-recorder}/bin:${pkgs.libnotify}/bin:${pkgs.xdg-utils}/bin:${pkgs.recording-indicator}/bin
''
