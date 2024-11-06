{
  stdenvNoCC,
  pkgs,
  makeDesktopItem,
  symlinkJoin,
  ...
}: let
  name = "Uncrashed - FPV Drone Simulator";
  pname = "uncrashed";
  exePath = "${drv}/share/${pname}/source/Uncrashed.exe";
  runner = "${pkgs.umu}/bin/umu-run";

  desktopItem = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = name;
      categories = ["Game"];
    })
  ];

  drv = stdenvNoCC.mkDerivation {
    inherit name pname;

    src = fetchTarball {
      url = "file:///mnt/storage/Games/uncrashed-fpv-drone-simulator_win64.tar.lrz";
      sha256 = "sha256:17kchwbyxz7jndgicgyh7jphszcalij18664vq68s2b286r1xh88";
    };

    sourceRoot = ".";

    nativeBuildInputs = with pkgs; [
      lrzip
      p7zip
    ];

    installPhase = ''
      mkdir -p $out/{bin,share/{${pname},pixmaps}}
      mv * $out/share/${pname}
      7z e -so $src/Uncrashed.exe .rsrc/ICON/5 > $out/share/pixmaps/${pname}.png
    '';
  };

  wrapper =
    pkgs.writeShellScriptBin
    pname
    ''
      export GAMEID=1682970
      export PROTONPATH=GE-Proton
      ${runner} winetricks vcrun2022
      ${runner} ${exePath}
    '';
in
  symlinkJoin {
    name = pname;
    paths = [
      wrapper
      desktopItem
    ];
  }
