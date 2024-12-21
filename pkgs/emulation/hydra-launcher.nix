{pkgs, ...}: let
  pname = "hydra-launcher";
  version = "3.0.8";

  src = pkgs.fetchurl {
    url = "https://github.com/hydralauncher/hydra/releases/download/v${version}/hydralauncher-${version}.AppImage";
    hash = "sha256-zU3SYfZ9wzVHQ9SZ8l1cV4g6vhSzqzPHOyNlx/T6DP0=";
  };

  desktop = "hydralauncher.desktop";

  appimageContents = pkgs.appimageTools.extract {inherit pname src version;};
in
  pkgs.appimageTools.wrapType1 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${desktop} -t $out/share/applications
      substituteInPlace $out/share/applications/${desktop} --replace-fail 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  }
