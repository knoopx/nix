{
  pkgs,
  nix-update-script,
  ...
}: let
  pname = "script-kit";
  version = "3.20.9";
  src = pkgs.fetchurl {
    url = "https://github.com/script-kit/app/releases/download/v${version}/Script-Kit-Linux-${version}-x86_64.AppImage";
    sha256 = "sha256-z8g8+fs2vFd/Pnl3wx+CHlVPtZalucYbxaL2bYU9SXk=";
  };
  appimage = pkgs.appimageTools.extractType2 {inherit pname version src;};
in
  pkgs.appimageTools.wrapType2
  {
    inherit pname version src;

    nativeBuildInputs = with pkgs; [
      makeWrapper
    ];

    extraInstallCommands = ''
      mkdir -p $out/{share,bin/resources}
      install -m 755 -D ${appimage}/scriptkit.desktop -t $out/share/applications
      cp -r ${appimage}/usr/share/ $out/share/
      cp -r ${appimage}/resources/ $out/bin/resources/
      wrapProgram "$out/bin/script-kit" --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --disable-features=WaylandFractionalScaleV1"
    '';

    passthru.updateScript =
      nix-update-script {
      };
  }
