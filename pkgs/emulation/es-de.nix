{
  pkgs,
  nix-update-script,
  ...
}: let
  # https://gitlab.com/es-de/emulationstation-de/-/releases
  pname = "es-de";
  version = "3.1.1";
  src = pkgs.fetchurl {
    url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/164503027/download";
    sha256 = "sha256-TvGABOpO/PWtcK+MogyMCS39T47Hz1+bv3Dz2yM284Q=";
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

    passthru.updateScript = nix-update-script {extraArgs = ["--version=skip"];};
  }
