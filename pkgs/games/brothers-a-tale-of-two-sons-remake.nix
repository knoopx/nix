{
  pkgs,
  symlinkJoin,
  makeDesktopItem,
  ...
}: let
  steam = pkgs.callPackage ../../lib/steam.nix {};

  name = "Brothers: A Tale of Two Sons Remake";
  pname = "brothers-a-tale-of-two-sons-remake";
  gameId = 2153350;

  wrapper = steam.umuDwarfWrapper {
    inherit pname gameId;
    entrypoint = "Brothers/Binaries/Win64/Brothers-Win64-Shipping.exe";
    dwarf = "/mnt/storage/Games/brothers-a-tale-of-two-sons-remake.dwarf";
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
    inherit pname;
    version = toString gameId;

    paths = [
      wrapper
      desktopItem
    ];
  }
