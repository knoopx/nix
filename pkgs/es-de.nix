{
  pkgs,
  nix-update-script,
  ...
}: let
  # https://gitlab.com/es-de/emulationstation-de/-/releases
  pname = "es-de";
  version = "3.2.0";
  src = pkgs.fetchurl {
    url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/184126704/download";
    sha256 = "sha256-e1WQA8b4h1ErhpLQBYVUh+92nVLpb2XRhk4btbmaWe4=";
  };
  appimage = pkgs.appimageTools.extractType2 {inherit pname version src;};
in
  pkgs.appimageTools.wrapType2
  {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 755 -D ${appimage}/org.es_de.frontend.desktop -t $out/share/applications
      install -m 644 -D ${appimage}/org.es_de.frontend.svg $out/share/icons/hicolor/scalable/apps/org.es_de.frontend.svg
      echo "StartupWMClass=es-de" >> $out/share/applications/org.es_de.frontend.desktop
      cp -r ${appimage}/usr/bin/resources/ $out/bin/resources/
    '';

    passthru.updateScript = nix-update-script {extraArgs = ["--version=skip"];};
  }
