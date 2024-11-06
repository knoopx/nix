{pkgs, ...}: let
  pname = "es-de";
  version = "3.1.0";
  src = pkgs.fetchurl {
    url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/147580930/download";
    sha256 = "sha256-TmjFjQ995dwO00mIjHA2d1SLEUTeyULAzik6psruF/w=";
  };
  appimage = pkgs.appimageTools.extractType2 {inherit pname version src;};
in
  pkgs.appimageTools.wrapType2
  {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 755 -D ${appimage}/org.es_de.frontend.desktop -t $out/share/applications
      install -m 644 -D ${appimage}/org.es_de.frontend.svg $out/share/icons/hicolor/scalable/apps/org.es_de.frontend.svg
      cp -r ${appimage}/usr/bin/resources/ $out/bin/resources/
    '';
  }
