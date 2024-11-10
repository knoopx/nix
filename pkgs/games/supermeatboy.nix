{
  stdenv,
  pkgs,
  unzip,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  SDL2,
  openalSoft,
  symlinkJoin,
}: let
  name = "Super Meat Boy";
  pname = "supermeatboy";
  version = "06072012";

  drv = stdenv.mkDerivation rec {
    inherit name pname version;

    src = fetchTree {
      type = "file";
      url = "file:///mnt/storage/Games/supermeatboy-linux-${version}-bin";
      narHash = "sha256-uTXyz7MUHS3g7S2Q2k4e38zvjPKsohkhHjrPfIasakU=";
    };
    sourceRoot = ".";

    nativeBuildInputs = [
      unzip
      autoPatchelfHook
    ];

    buildInputs = [
      stdenv.cc.cc.lib
      SDL2
      openalSoft
    ];

    unpackCmd = "unzip -u $src || true";

    installPhase = ''
      rm -rf data/SuperMeatBoy data/x86
      rm -f data/amd64/{libopenal.so.1,libSDL2-2.0.so.0}
      mkdir -p $out/{bin,share/{supermeatboy,pixmaps}}
      mv data/* $out/share/${pname}
      install -m 444 -D $out/share/${pname}/supermeatboy.png $out/share/pixmaps/${pname}.png
    '';
  };

  wrapper = pkgs.writeShellScriptBin pname ''
    pushd ${drv}/share/supermeatboy/
    amd64/SuperMeatBoy-amd64 "$@"
  '';
in
  makeDesktopItem {
    name = pname;
    exec = "${wrapper}/bin/${pname}";
    icon = "${drv}/share/pixmaps/${pname}.png";
    desktopName = name;
    categories = ["Game"];
  }
