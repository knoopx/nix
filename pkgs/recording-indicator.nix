{pkgs}:
pkgs.runCommand "recording-indicator" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "recording-indicator";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/recording-indicator \
    --add-flags ${./recording-indicator.nu} \
    --prefix PATH : ${pkgs.kitty}/bin:${pkgs.bash}/bin:${pkgs.procps}/bin
''
