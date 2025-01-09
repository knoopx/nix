{
  pkgs,
  symlinkJoin,
  makeDesktopItem,
  ...
}: let
  steam = pkgs.callPackage ../../lib/steam.nix {};

  name = "Driver: San Francisco";
  pname = "driver-san-francisco";
  gameId = 33440;

  wrapper = steam.umuDwarfWrapper {
    inherit pname gameId;
    entrypoint = "Driver.exe";
    dwarf = "/mnt/storage/Games/driver-san-francisco_win32.dwarf";
  };

  desktopItem = [
    (makeDesktopItem {
      desktopName = name;
      name = pname;
      exec = pname;
      icon = pname;
      categories = ["Game"];
    })
  ];
in
  symlinkJoin {
    inherit name pname;
    version = toString gameId;

    paths = [
      wrapper
      desktopItem
    ];
  }
