# https://raw.githubusercontent.com/codestoryai/binaries/main/linux/linux_install.sh
{
  pkgs,
  fetchurl,
  lib,
  glib,
  libdbusmenu,
  nix-update-script,
  ...
}: (
  (pkgs.callPackage "${pkgs.path}/pkgs/applications/editors/vscode/generic.nix" rec {
    pname = "aide";
    version = "1.94.2.24312";

    executableName = "aide";
    shortName = "Aide";
    longName = "Aide";
    commandLineArgs = "";

    updateScript = nix-update-script;

    src = fetchurl {
      url = "https://github.com/codestoryai/binaries/releases/download/${version}/Aide-linux-x64-${version}.tar.gz";
      sha256 = "sha256-bdCb91Q0IFmMuP1PNJXSv4I+5mCSXIXJyd9N+8ViITw=";
    };
    sourceRoot = ".";

    meta = {};
  })
  .overrideAttrs
  {
    preFixup = ''
      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libdbusmenu]}
        --prefix PATH : ${glib.bin}/bin
      )
    '';
  }
)
