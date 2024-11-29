{pkgs, ...}: let
  name = "hydra-launcher";
  version = "3.0.5";

  src = pkgs.fetchurl {
    url = "https://github.com/hydralauncher/hydra/releases/download/v${version}/hydralauncher-${version}.AppImage";
    hash = "sha256-KATrn9fqXzMftVwafA3wCWbBqldZbT6loc0EfvnvnPg=";
  };

  desktop = "hydralauncher.desktop";

  appimageContents = pkgs.appimageTools.extractType1 {inherit name src;};
in
  pkgs.appimageTools.wrapType1 {
    inherit name src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${desktop} -t $out/share/applications
      substituteInPlace $out/share/applications/${desktop} --replace-fail 'Exec=AppRun' 'Exec=${name}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  }
