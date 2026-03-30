{pkgs}:
pkgs.runCommand "recording-indicator" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "recording-indicator";
} ''
  mkdir -p $out/bin
  cp ${./recording-indicator.nu} $out/bin/recording-indicator.nu
  chmod +x $out/bin/recording-indicator.nu
  makeWrapper $out/bin/recording-indicator.nu $out/bin/recording-indicator \
    --prefix PATH : ${pkgs.nushell}/bin:${pkgs.kitty}/bin:${pkgs.bash}/bin:${pkgs.procps}/bin
''
