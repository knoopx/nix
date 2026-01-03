{pkgs}:
pkgs.runCommand "google-authenticator-qr-decode" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  runtimeInputs = [pkgs.zbar pkgs.otpauth];
  meta.mainProgram = "google-authenticator-qr-decode";
} ''
  mkdir -p $out/bin
  cp ${./google-authenticator-qr-decode.nu} $out/bin/google-authenticator-qr-decode.nu
  chmod +x $out/bin/google-authenticator-qr-decode.nu
  makeWrapper $out/bin/google-authenticator-qr-decode.nu $out/bin/google-authenticator-qr-decode \
    --suffix PATH : ${pkgs.zbar}/bin:${pkgs.otpauth}/bin
''
