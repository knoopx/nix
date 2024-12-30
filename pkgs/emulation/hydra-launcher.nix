{
  pkgs,
  nix-update-script,
  ...
}: let
  pname = "hydra-launcher";
  version = "3.1.2";

  src = pkgs.fetchurl {
    url = "https://github.com/hydralauncher/hydra/releases/download/v${version}/hydralauncher-${version}.AppImage";
    hash = "sha256-Di5m2GhRxItlBOxfNH5Xyf1Tnj/fTQeILd2F5zZ7XNU=";
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

    passthru.updateScript = nix-update-script {};
  }
