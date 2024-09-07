{pkgs, ...}: let
  # TODO: scraper crashes probably due to freeimage
  pname = "es-de";
  version = "3.0.3";
  src = pkgs.fetchurl {
    url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/132901118/download";
    sha256 = "sha256-cMLmTvnH4CGhIZsrTk/LsJBBxuNwFHyMchJQCG7EoOE=";
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
