{pkgs}:
pkgs.runCommand "voice-input-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "voice-input-control";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/voice-input-control \
    --add-flags ${./voice-input-control.nu} \
    --prefix PATH : ${pkgs.nushell}/bin:${pkgs.voxtype-vulkan}/bin:${pkgs.recording-indicator}/bin
''
