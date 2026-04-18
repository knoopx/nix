{pkgs}:
pkgs.runCommand "google-authenticator-qr-decode" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  runtimeInputs = [pkgs.zbar pkgs.otpauth];
  meta.mainProgram = "google-authenticator-qr-decode";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/google-authenticator-qr-decode \
    --add-flags ${./google-authenticator-qr-decode.nu} \
    --suffix PATH : ${pkgs.zbar}/bin:${pkgs.otpauth}/bin
''
