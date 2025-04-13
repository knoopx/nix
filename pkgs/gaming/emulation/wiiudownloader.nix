{
  pkgs,
  nix-update-script,
  ...
}: let
  pname = "wiiudownloader";
  version = "2.60";

  src = pkgs.fetchurl {
    url = "https://github.com/Xpl0itU/WiiUDownloader/releases/download/v${version}/WiiUDownloader-Linux-x86_64.AppImage";
    hash = "sha256-FPZODciFFChY4afNdmuovA0ongwTioxYhYdY1/Clff0=";
  };

  desktop = "WiiUDownloader.desktop";

  appimageContents = pkgs.appimageTools.extractType1 {inherit pname version src;};
in
  pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${desktop} -t $out/share/applications

      substituteInPlace $out/share/applications/${desktop} \
        --replace-fail 'Exec=WiiUDownloader' 'Exec=${pname}'

      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    passthru.updateScript = nix-update-script {extraArgs = ["--version=skip"];};
  }
