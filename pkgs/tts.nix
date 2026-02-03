{pkgs}:
pkgs.runCommand "tts" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "tts";
} ''
  mkdir -p $out/bin
  cp ${./tts.sh} $out/bin/tts
  chmod +x $out/bin/tts
''
