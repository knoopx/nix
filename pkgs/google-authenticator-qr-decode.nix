{pkgs}:
pkgs.writeShellApplication {
  name = "google-authenticator-qr-decode";
  runtimeInputs = [pkgs.zbar pkgs.otpauth];
  text = ''
    set -euo pipefail

    line=$(zbarcam -1 --quiet)

    if [[ -z "$line" ]]; then
      echo "Error: No QR code detected." >&2
      exit 1
    fi

    uri="''${line#QR-Code:}"

    if [[ "$uri" != otpauth://* ]]; then
      echo "Error: Detected QR code does not appear to be an otpauth URI." >&2
      exit 1
    fi

    otpauth -link "$uri"
  '';
}
