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
  drv = stdenv.mkDerivation rec {
    pname = "supermeatboy";
    version = "06072012";

    src = fetchTree {
      type = "file";
      url = "file:///mnt/storage/Games/supermeatboy-linux-${version}-bin";
      narHash = "sha256-uTXyz7MUHS3g7S2Q2k4e38zvjPKsohkhHjrPfIasakU=";
    };
    sourceRoot = ".";

    nativeBuildInputs = [
      unzip
      autoPatchelfHook
      copyDesktopItems
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
      mv data/* $out/share/supermeatboy
      ln -s $out/share/supermeatboy/supermeatboy.png $out/share/pixmaps/${pname}.png
    '';
  };

  desktopItems = [
    (makeDesktopItem {
      name = drv.pname;
      exec = drv.pname;
      icon = drv.pname;
      comment = "Super Meat Boy";
      desktopName = "Super Meat Boy";
      categories = ["Game"];
    })
  ];
in
  symlinkJoin {
    inherit (drv) pname version;

    paths = [
      (
        pkgs.writeShellScriptBin drv.pname ''
          pushd ${drv}/share/supermeatboy/
          amd64/SuperMeatBoy-amd64 "$@"
        ''
      )
      desktopItems
    ];
  }
