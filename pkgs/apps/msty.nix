{pkgs}: let
  name = "${pname}-${version}";
  pname = "msty";
  version = "1.0.0";

  src = pkgs.fetchurl {
    url = "https://assets.msty.app/prod/latest/linux/amd64/Msty_x86_64_amd64.AppImage";
    sha256 = "sha256-9ft9vK4RjzWcX/9iy17UkqWKYnPZdZORd3fxib+NsTc=";
  };

  appimage = pkgs.appimageTools.extractType2 {inherit pname version src;};
in
  pkgs.appimageTools.wrapType2 rec {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 755 -D ${appimage}/msty.desktop -t $out/share/applications
      install -m 644 -D ${appimage}/msty.png $out/share/icons/hicolor/scalable/apps/msty.png
      cp -r ${appimage}/resources/ $out/resources/
    '';

    meta = {homepage = "https://msty.app";};
  }
