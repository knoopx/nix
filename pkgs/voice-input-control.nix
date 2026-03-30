{pkgs}:
pkgs.runCommand "voice-input-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "voice-input-control";
} ''
  mkdir -p $out/bin
  cp ${./voice-input-control.nu} $out/bin/voice-input-control.nu
  chmod +x $out/bin/voice-input-control.nu
  makeWrapper $out/bin/voice-input-control.nu $out/bin/voice-input-control \
    --prefix PATH : ${pkgs.nushell}/bin:${pkgs.voxtype-vulkan}/bin:${pkgs.recording-indicator}/bin
''
