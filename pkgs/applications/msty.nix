{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "msty";
  version = "1.0.0";

  src = fetchurl {
    url = https://assets.msty.app/prod/latest/linux/amd64/Msty_...AppImage;
    sha256 = "TODO: Add the actual hash here"; # You'll need to calculate this
  };

  installPhase = ''
    install -D -m 0755 $src $out/bin/msty
  '';

  meta = {
    description = "Msty application";
    license = lib.licenses.unknown; # Replace with actual license if available
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.yourName ]; # Add your maintainer info
  };
}
